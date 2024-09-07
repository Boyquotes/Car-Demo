@tool
@icon("res://addons/crypto/icons/CryptoIcon3D.svg")
class_name BoxCrypto_3D
extends Label3D

const requestsManager = preload("res://scenes/requestsManager.tscn")

@export var Symbol = "BTC"
@export var numberCoin = ""
@export var averagePrice = ""
@export var totalPrice = ""
@export var totalActualPrice = ""

@export var crypto = get_node(".")

var wait_time = 5
signal timeout
var timer
var format_string = "%*.*f"

func _enter_tree() -> void:
	print('crypto')
	print(crypto)
	print(crypto.font_size)
	#if crypto.font_size == 32:
	#	crypto.font_size=320
	
#var Properties: Object = preload("res://addons/phantom_camera/scripts/phantom_camera/phantom_camera_properties.gd").new()
func _ready():
	timer = Timer.new()
	timer.set_wait_time(wait_time)
	add_child(timer)
	timer.start()
	timer.connect("timeout", _on_Timer_timeout)
	
	var meshTabCrypto = MeshInstance3D.new()
	meshTabCrypto.mesh = BoxMesh.new()
	var material = StandardMaterial3D.new()
	if float(totalActualPrice) > float(totalPrice):
		material.albedo_color = Color(0.0, 0.8, 0.0)
	else:
		material.albedo_color = Color(0.8, 0.0, 0.0)
	#var shinyOrangeMat = preload("res://shiny_orange_mat.tres")
	meshTabCrypto.material_override = material
	var m = Transform3D()
	#var m = Basis()
	print(m)
	m = m.scaled(Vector3(8,8,1))
	meshTabCrypto.transform = m
	meshTabCrypto.transform.origin = Vector3(-10, 0, 0)
	add_child(meshTabCrypto)


	var n = Transform3D()
	n = n.scaled(Vector3(0.5,1,1))
	var cryptoSymbol = Label3D.new()
	cryptoSymbol.text = Symbol
	cryptoSymbol.modulate = Color(0.0, 0.0, 0.8)
	cryptoSymbol.outline_modulate = Color(0.5, 0.5, 0.5)
	cryptoSymbol.transform = n
	cryptoSymbol.transform.origin = Vector3(0, 0.4, 0.7)
	print(cryptoSymbol)
	meshTabCrypto.add_child(cryptoSymbol)

	var cryptoPrice = Crypto3D.new()
	cryptoPrice.Symbol = Symbol
	cryptoPrice.transform = n
	cryptoPrice.transform.origin = Vector3(0, 0.2, 0.7)
	print(cryptoPrice)
	meshTabCrypto.add_child(cryptoPrice)

	var cryptoNumberCoin = Label3D.new()
	cryptoNumberCoin.text = str(format_string % [1, 2, float(numberCoin)])+" "+Symbol
	cryptoNumberCoin.transform = n
	cryptoNumberCoin.transform.origin = Vector3(0, 0, 0.7)
	print(cryptoNumberCoin)
	meshTabCrypto.add_child(cryptoNumberCoin)

	var cryptoTotalPrice = Label3D.new()
	cryptoTotalPrice.text = str(format_string % [1, 2, float(totalPrice)])+" $"
	cryptoTotalPrice.transform = n
	cryptoTotalPrice.transform.origin = Vector3(0, -0.15, 0.7)
	print(cryptoTotalPrice)
	meshTabCrypto.add_child(cryptoTotalPrice)

	var cryptoTotalActualPrice = Label3D.new()
	cryptoTotalActualPrice.text = str(format_string % [1, 2, float(totalActualPrice)])+" $"
	cryptoTotalActualPrice.transform = n
	cryptoTotalActualPrice.transform.origin = Vector3(0, -0.30, 0.7)
	print(cryptoTotalActualPrice)
	meshTabCrypto.add_child(cryptoTotalActualPrice)

	#timer = get_parent().get_node("Timer")
#	pass

func rotate90():
	var axis = Vector3(0, 1, 0) # Or Vector3.RIGHT
	var rotation_amount = 1.57
	transform.basis = Basis(axis, rotation_amount) * transform.basis

func rotate180():
	var axis = Vector3(0, 1, 0) # Or Vector3.RIGHT
	var rotation_amount = 3.14
	transform.basis = Basis(axis, rotation_amount) * transform.basis

func rotate270():
	var axis = Vector3(0, 1, 0) # Or Vector3.RIGHT
	var rotation_amount = 4.71
	transform.basis = Basis(axis, rotation_amount) * transform.basis

func _on_Timer_timeout():
	print('lalalaBox')
#	print(get_node("."))
#	print(get_node(".").Symbol)
#	_request_price(get_node("."))

func _request_price(crypto):
	var HTTPManagerCrypto = requestsManager.instantiate()
	add_child(HTTPManagerCrypto)
#	$HTTPManager.job(
	#	"http://5.39.89.79:3003/api/binance/prices"
#	https://www.binance.com/api/v3/ticker/price?symbol=BTCUSDT
	$HTTPManager.job(
		"https://www.binance.com/api/v3/ticker/price?symbol="+Symbol+"USDT"
	).on_success( 
		func(response): 
			print("This JSON for Binance is what i got:");
			var cryptoData = response.fetch()
#			print(response.fetch())
#			var json = JSON.new()
#			json.parse(body.get_string_from_utf8())
#			var response = json.get_data()
			print(response)
			print(cryptoData)
			#if(response && response.bddCrypto):
			if(response && cryptoData.price):
				#self.text=str(response.bddCrypto.actualPrice)+" "+self.Symbol
				if(float(cryptoData.price) >= 1 and float(cryptoData.price) >= 0.1):
		#			self.text=str(format_string % [1, 2, float(response.price)])+" "+self.Symbol
					self.text=str(format_string % [1, 3, float(cryptoData.price)])+" $"
				elif(float(cryptoData.price) < 0.1 and float(cryptoData.price) >= 0.001):
		#			self.text=str(format_string % [1, 2, float(response.price)])+" "+self.Symbol
					self.text=str(format_string % [1, 5, float(cryptoData.price)])+" $"
				elif(float(cryptoData.price) < 0.001):
		#			self.text=str(format_string % [1, 2, float(response.price)])+" "+self.Symbol
					self.text=str(format_string % [1, 8, float(cryptoData.price)])+" $"
				else:
		#			self.text=str(format_string % [1, 4, float(response.price)])+" "+self.Symbol
					self.text=str(format_string % [1, 2, float(cryptoData.price)])+" $"
	).on_failure(
		func( _response ): print("I told this wont work!")
	).fetch()

func _process(delta):
	#print(delta)
	pass
