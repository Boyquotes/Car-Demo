extends Label3D

@onready var portfolio_address = SolanaService.wallet.get_pubkey();

# Called when the node enters the scene tree for the first time.
func _ready():
	print("portfolio_address", portfolio_address)
	$".".text = portfolio_address.to_string()
	var connected_wallet:Pubkey = SolanaService.wallet.get_pubkey()
	var wallet_assets:Array[Dictionary] = await SolanaService.get_wallet_assets(connected_wallet.to_string())
	for asset in wallet_assets:
		print("asset ", asset)
	var wallet_balance:float = await SolanaService.get_balance(connected_wallet.to_string())
	print("wallet_balance ", wallet_balance)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
