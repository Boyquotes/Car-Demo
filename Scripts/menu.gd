extends CanvasLayer

@export var main_scn: PackedScene
@export var wallet_adapter: WalletAdapterUI #TO SHOW WALLET POPUP

# Called when the node enters the scene tree for the first time.
func _ready():
	SolanaService.wallet.connect("on_login_finish", load_game)
	SolanaService.wallet.connect("on_login_begin", pop_adapter) #TO SHOW WALLET POPUP
	
	wallet_adapter.connect("on_provider_selected", handle_provider_selected)
	wallet_adapter.connect("on_adapter_cancel", close_adapter)
	
	wallet_adapter.visible= false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_connect_button_pressed():
	SolanaService.wallet.try_login()
	
func load_game(succcess:bool) -> void:
	if succcess:
		print("SUCCESS")
		get_tree().change_scene_to_file("res://main.tscn")
		#var player_data:Dictionary = await soar_program.fetch_player_data(SolanaService.wallet.get_pubkey())
		#if player_data.size()>0:
			#get_tree().change_scene_to_file("res://scenes/main.tscn")
		#else:
			#get_tree().change_scene_to_file("res://scenes/create_account.tscn")

#TO SHOW WALLET POPUP
func pop_adapter() -> void:
	wallet_adapter.visible= true
	wallet_adapter.setup(SolanaService.wallet.wallet_adapter.get_available_wallets())

func handle_provider_selected(id: int) -> void:
	SolanaService.wallet.login_adapter(id)
	
func close_adapter() -> void:
	wallet_adapter.visible = false
