@tool
@icon("res://addons/crypto/icons/CryptoIcon3D.svg")
class_name Crypto3D
extends Label3D

#const requestsManager = preload("res://scenes/requestsManager.tscn")

@export var Symbol = "BTC"

@export var crypto = get_node(".")
var wait_time = 2
signal timeout
var timer
var format_string = "%*.*f"

@onready var requestsManager : HTTPManager = %HTTPManager

func _enter_tree() -> void:
	print('crypto')
	print(crypto)
	print(crypto.font_size)
	#if crypto.font_size == 32:
	#	crypto.font_size=320
	_request_price(crypto)
	
#var Properties: Object = preload("res://addons/phantom_camera/scripts/phantom_camera/phantom_camera_properties.gd").new()
func _ready():
	#timer = get_parent().get_node("Timer")
	timer = Timer.new()
	timer.set_wait_time(wait_time)
	add_child(timer)
	timer.start()
	timer.connect("timeout", _on_Timer_timeout)

func _process(delta):
	#print(delta)
	pass

func _on_Timer_timeout():
	print('lalala4')
#	print(get_node("."))
#	print(get_node(".").Symbol)
	_request_price(get_node("."))


func _exit_tree():
	timer.stop()
	queue_free()

func _request_price(crypto):
	var HTTPManagerCrypto = requestsManager.instantiate()
	add_child(HTTPManagerCrypto)
	#	"http://5.39.89.79:3003/api/binance/prices"
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
			print(response.fetch())
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
				elif(float(cryptoData.price) < 0.01):
		#			self.text=str(format_string % [1, 2, float(response.price)])+" "+self.Symbol
					self.text=str(format_string % [1, 6, float(cryptoData.price)])+" $"
				elif(float(cryptoData.price) < 0.001):
		#			self.text=str(format_string % [1, 2, float(response.price)])+" "+self.Symbol
					self.text=str(format_string % [1, 7, float(cryptoData.price)])+" $"
				else:
		#			self.text=str(format_string % [1, 4, float(response.price)])+" "+self.Symbol
					self.text=str(format_string % [1, 2, float(cryptoData.price)])+" $"
	).on_failure(
		func( _response ): print("I told this wont work!")
	).fetch()
	#HTTPRequest.request("http://www.mocky.io/v2/5185415ba171ea3a00704eed")
	# Create an HTTP request node and connect its completion signal.
#	var http_request = HTTPRequest.new()
#	add_child(http_request)
#	http_request.request_completed.connect(self._http_request_completed)
	#var crypto = get_node("Crypto3D")
	#crypto.set_text="Price"

	# Perform the HTTP request. The URL below returns a PNG image as of writing.
	# var error = http_request.request("https://via.placeholder.com/512")
	#var error = http_request.request("https://jsonplaceholder.typicode.com/todos/1")
#	print(Symbol)
#	print(crypto.Symbol)
	#var error = http_request.request("http://5.39.89.79:3003/api/portfolio/listOneWallet/"+get_node(".").Symbol)
#	var error = http_request.request("https://www.binance.com/api/v3/ticker/price?symbol="+Symbol+"USDT")
	
#	if error != OK:
#		push_error("An error occurred in the HTTP request.")

# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")
	#var crypto = get_parent().get_node("Crypto3D")
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	print(response )
	#if(response && response.bddCrypto):
	if(response && response.price):
		#self.text=str(response.bddCrypto.actualPrice)+" "+self.Symbol
		if(float(response.price) >= 1):
#			self.text=str(format_string % [1, 2, float(response.price)])+" "+self.Symbol
			self.text=str(format_string % [1, 2, float(response.price)])+" $"
		else:
#			self.text=str(format_string % [1, 4, float(response.price)])+" "+self.Symbol
			self.text=str(format_string % [1, 2, float(response.price)])+" $"
	#var image = Image.new()
	#var error = image.load_png_from_buffer(body)
	#if error != OK:
	#	push_error("Couldn't load the image.")

	#var texture = ImageTexture.create_from_image(image)
	# Display the image in a TextureRect node.
	#var texture_rect = TextureRect.new()
	#add_child(texture_rect)
	#texture_rect.texture = texture

#func _physics_process(delta: float) -> void:
	#print('plugin')
	


func _on_crypto_price_3d_timeout():
	print('lalala3')
