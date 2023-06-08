import pdb


class Config(pdb.DefaultConfig):
    use_pygments = True
    pygments_formatter_class = "pygments.formatters.terminal256.Terminal256Formatter"
    pygments_formatter_kwargs = {"style": "monokai"}
    show_hidden_frames_count = False
    sticky_by_default = True
