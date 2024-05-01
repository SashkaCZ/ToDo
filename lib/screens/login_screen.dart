import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tododo/repo/auth_repo.dart'; 

class LoginScreen extends StatelessWidget {
   LoginScreen({super.key});

 final AuthRepository _authRepo = AuthRepository();
final TextEditingController _controllerUsername = TextEditingController();
final TextEditingController _controllerPassword = TextEditingController();

final Box _boxLogin = Hive.box("login");
final Box _boxAccounts = Hive.box("accounts");

bool _obscurePassword = true;
  @override
  Widget build(BuildContext context) {
     if (_boxLogin.get("loginStatus") ?? false) {
      return LoginScreen();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вход'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Form(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 150),
              Text(
                "Добро пожаловать",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 10),
              Text(
                "Введите Email и пароль для входа",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 60),
              TextFormField(
                controller: _controllerUsername,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Введите Email",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Введите логин.";
                  } else if (_boxAccounts.containsKey(value)) {
                    return "Логин уже используется.";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerPassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: "Введите пароль",
                  prefixIcon: const Icon(Icons.password_outlined),
                  suffixIcon: IconButton(
                    onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                    },
                    icon: _obscurePassword
                          ? const Icon(Icons.visibility_outlined)
                          : const Icon(Icons.visibility_off_outlined),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Введите пароль.";
                  } else if (value !=
                      _boxAccounts.get(_controllerUsername.text)) {
                    return "Неверный пароль.";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 60),
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5.0,
                      backgroundColor: Color.fromRGBO(117, 110, 243, 1),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/taskList');
                      },
                      //Поскольку API не работает, кнопка входа сразу перенаправляет на экран с задачами
                    // onPressed: () async {
                    //   // Вызываем метод входа из репозитория аутентификации
                    //   try {
                    //     await _authRepo.login(
                    //       _controllerUsername.text,
                    //       _controllerPassword.text,
                    //     );
                    //     // Переходим на экран списка задач после успешного входа
                    //     Navigator.pushReplacementNamed(context, '/taskList');
                    //   } catch (error) {
                    //     // Обрабатываем ошибку при входе
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       SnackBar(content: Text('Ошибка при входе: $error')),
                    //     );
                    //   }
                    // },
                    child: const Text("Вход", style: TextStyle(
                      color: Colors.white
                    ),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Нет аккаунта?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text("Зарегестрироваться"),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  
  void setState(Null Function() param0) {}
}
