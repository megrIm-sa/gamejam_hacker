extends RichTextLabel

func _on_rich_text_label_meta_clicked(meta):
	if typeof(meta) == TYPE_STRING and meta.begins_with("http"):
		OS.shell_open(meta)
