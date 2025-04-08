describe_image() {
  local prompt="think about the relationships in the image and describe only the unique details in the image, concise, so I can paste it into a ticket"
  # Save clipboard image to a temporary PNG file (requires pngpaste)
  rm -f /tmp/clipboard_image.png
  local temp_image
  temp_image=$(mktemp /tmp/clipboard_image.png)
  pngpaste "$temp_image" || {
    echo "No image found in clipboard"
    return 1
  }

  # Encode the image to base64
  local base64_image
  base64_image=$(base64 <"$temp_image" | tr -d '\n')

  # Get file size in bytes
  local file_size
  file_size=$(wc -c <"$temp_image")

  # Calculate approximate image tokens
  local image_tokens=$((file_size / 3))

  # Send request and capture full response
  local response
  response=$(curl -s https://api.anthropic.com/v1/messages \
    -H "Content-Type: application/json" \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    -d '{
      "model": "claude-3-5-sonnet-20240620",
      "max_tokens": 1000,
      "messages": [
        {
          "role": "user",
          "content": [
            {
              "type": "text",
              "text": "'"$prompt"'"
            },
            {
              "type": "image",
              "source": {
                "type": "base64",
                "media_type": "image/png",
                "data": "'"$base64_image"'"
              }
            }
          ]
        }
      ]
    }')

  # Clean control characters from the response
  local clean_response
  clean_response=$(echo "$response" | tr -d '\000-\037')

  # Extract the content and usage info
  local content
  content=$(echo "$clean_response" | jq -r '.content[0].text')
  local input_tokens
  input_tokens=$(echo "$clean_response" | jq -r '.usage.input_tokens')
  local output_tokens
  output_tokens=$(echo "$clean_response" | jq -r '.usage.output_tokens')

  # Calculate approximate cost (USD per 1K tokens, March 2024 pricing)
  local input_cost
  input_cost=$(echo "scale=4; $input_tokens * 0.00025 / 1000" | bc)
  local output_cost
  output_cost=$(echo "scale=4; $output_tokens * 0.00075 / 1000" | bc)
  local total_cost
  total_cost=$(echo "scale=4; $input_cost + $output_cost" | bc)

  # Print the content and cost info
  echo "$content"
  echo ""
  echo "Approximate cost:"
  echo "Input tokens: $input_tokens"
  echo "Output tokens: $output_tokens"
  echo "Total cost: \$${total_cost}"

  # Clean up temporary file
  rm "$temp_image"
}
