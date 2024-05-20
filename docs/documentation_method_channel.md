# Usando Method Channel no Flutter para Obter o Nível de Bateria do Dispositivo

  

Neste artigo, vamos criar um aplicativo Flutter que obtém o nível de bateria do dispositivo usando o Method Channel. Implementaremos a funcionalidade nativa em Kotlin para Android e Swift para iOS.

  

## Introdução

  

O Method Channel no Flutter permite a comunicação entre o código Dart e o código nativo, possibilitando que o Flutter invoque funções específicas do Android e do iOS.

  

## Configuração Inicial

  

Crie um novo projeto Flutter:

```bash

flutter  create  method_channel_flutter

cd  method_channel_flutter

```

  

## Implementação do Código Flutter

  

No arquivo `lib/battery_device_page.dart`, adicione o seguinte código:

  

### Configuração do Method Channel

  

Definimos um `MethodChannel` para comunicação com o código nativo:

```dart

static const platform = MethodChannel('com.example.battery/battery');

```

  

### Obtendo o Nível da Bateria

  

Criamos um método `_getBatteryLevel` que invoca o método nativo `getBatteryLevel`:

```dart

Future<void> _getBatteryLevel() async {
	String batteryLevel;
	double batteryPercentage;
	
	try {
		final  int result = await platform.invokeMethod('getBatteryLevel');
		batteryLevel = '$result';
		batteryPercentage = result / 100;
	} on  PlatformException  catch (e) {
		batteryLevel = "${e.message}";
		batteryPercentage = 0.0;
}

  

	setState(() {
		_batteryLevel = batteryLevel;
		_batteryPercentage = batteryPercentage;
		_controller.forward(from: 0.0);
	});

  

	_controller.addListener(() {
		if (_controller.status == AnimationStatus.completed) {
		_controller.forward(from: 0.0);
		}
	});

}

```

  

### Desenhando a Animação da Bateria

  

Criamos um `CustomPainter` para desenhar o nível de bateria de forma animada:

```dart

class  BatteryPainter  extends  CustomPainter {

final  double animationValue;
final  double fillPercentage;

BatteryPainter(this.animationValue, this.fillPercentage);

@override
void  paint(Canvas canvas, Size size) {
		final paint = Paint()..color = Colors.green..style = PaintingStyle.fill;
		final waveHeight = size.height * 0.02;
		final baseHeight = size.height * (1 - fillPercentage);

		final path = Path();
		path.moveTo(0, baseHeight);

		for (double x = 0; x <= size.width; x++) {
			final y = baseHeight +
			waveHeight *
			sin((x / size.width * 2 * pi) + animationValue);

			path.lineTo(x, y);

		}

		path.lineTo(size.width, size.height);
		path.lineTo(0, size.height);
		path.close();

		canvas.drawPath(path, paint);
	}

	  

	@override
	bool  shouldRepaint(covariant  CustomPainter oldDelegate) {
		return  true;
	}

}

```

  

## Implementação do Código Nativo para iOS

  

No arquivo `ios/Runner/AppDelegate.swift`, adicione o seguinte código:

  

### Configuração do Method Channel

  

Definimos um `FlutterMethodChannel` e o associamos ao `FlutterViewController`:

```swift

let controller : FlutterViewController = window?.rootViewController as! FlutterViewController

let batteryChannel = FlutterMethodChannel(name: "com.example.battery/battery",

binaryMessenger: controller.binaryMessenger)

batteryChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void  in

if call.method == "getBatteryLevel" {

self.receiveBatteryLevel(result: result)

} else {

result(FlutterMethodNotImplemented)

}

}

```

  

### Obtendo o Nível da Bateria

  

Implementamos a função `receiveBatteryLevel` para obter o nível da bateria:

```swift

private  func  receiveBatteryLevel(result: FlutterResult) {

	let device = UIDevice.current
	device.isBatteryMonitoringEnabled = true
	if device.batteryState == UIDevice.BatteryState.unknown {
		result(FlutterError(code: "UNAVAILABLE", message: "Battery level not available.", details: nil))
	} else {
		result(Int(device.batteryLevel * 100))
	}
}

```

  

## Implementação do Código Nativo para Android

  

No arquivo `android/app/src/main/kotlin/com/example/method_channel_flutter/MainActivity.kt`, adicione o seguinte código:

  

### Configuração do Method Channel

  

Definimos um `MethodChannel` e o associamos ao `FlutterEngine`:

```kotlin

private  val  CHANNEL = "com.example.battery/battery"

  

override  fun  configureFlutterEngine(flutterEngine: FlutterEngine) {

super.configureFlutterEngine(flutterEngine)

MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
		if (call.method == "getBatteryLevel") {
			val batteryLevel = getBatteryLevel()
			if (batteryLevel != -1) {
				result.success(batteryLevel)
			} else {
				result.error("UNAVAILABLE", "Battery level not available.", null)
			}
		} else {
			result.notImplemented()
		}
	}
}

```

  

### Obtendo o Nível da Bateria

  

Implementamos a função `getBatteryLevel` para obter o nível da bateria:

```kotlin

private  fun  getBatteryLevel(): Int {
	val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
	return batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
}

```

  
## Video da Aplicação


https://github.com/WemersonDamasceno/method_channel_flutter/assets/37156004/188cd1bf-ffc2-4234-b004-155cd9c33c9d

## Conclusão

  

Neste artigo, mostramos como usar o Method Channel no Flutter para obter o nível de bateria do dispositivo, implementando a funcionalidade nativa em Kotlin para Android e Swift para iOS. Este é um exemplo prático de como integrar funcionalidades nativas em um aplicativo Flutter, expandindo suas capacidades além do que é oferecido pela biblioteca padrão do Flutter.