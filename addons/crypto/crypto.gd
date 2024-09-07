@tool
extends EditorPlugin

const Crypto3D: String = "Crypto3D"

func _enter_tree():
	add_custom_type(Crypto3D, "Label3D", preload("res://addons/crypto/scripts/crypto_3D.gd"), preload("res://addons/crypto/icons/CryptoIcon3D.svg"))

func _exit_tree():
	remove_custom_type(Crypto3D)
