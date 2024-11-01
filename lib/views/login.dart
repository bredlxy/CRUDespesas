import 'package:flutter/material.dart';

/// Tela de Login da aplicação
class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Imagem de fundo que cobre toda a tela
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contêiner central que contém o formulário de login
          _buildLoginContainer(context),
        ],
      ),
    );
  }

  /// Contêiner principal para o formulário de login
  Widget _buildLoginContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const WelcomeText(),
          const SizedBox(height: 30),
          const Text(
            "E-mail",
            style: TextStyle(
              color: Color(0xFF9B9B9B),
              fontSize: 16,
              fontFamily: 'Satoshi',
            ),
          ),
          const SizedBox(height: 5),
          const CustomTextField(
            hintText: "Seu endereço de cadastro",
            imagePath: 'assets/img/ico_email.png',
            isPassword: false,
          ),
          const SizedBox(height: 20),
          const Text(
            "Senha",
            style: TextStyle(
              color: Color(0xFF9B9B9B),
              fontSize: 16,
              fontFamily: 'Satoshi',
            ),
          ),
          const SizedBox(height: 5),
          const CustomTextField(
            hintText: "************",
            imagePath: 'assets/img/ico_senha.png',
            isPassword: true,
          ),
          const SizedBox(height: 30),
          // Botão de login com gradiente centralizado
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9C8680), Color(0xFFCEBBB5)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Entrar",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontFamily: 'Satoshi',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Texto de saudação estilizado ("Seja bem-vindo(a)!")
class WelcomeText extends StatelessWidget {
  const WelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        children: [
          TextSpan(
            text: "Seja",
            style: TextStyle(
              fontFamily: 'Satoshi',
              fontSize: 28,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          TextSpan(
            text: " bem-vindo(a)!",
            style: TextStyle(
              fontFamily: 'Satoshi',
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// Campo de texto personalizado com suporte para ícones e entrada de senha
class CustomTextField extends StatefulWidget {
  final String hintText;
  final String imagePath;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.imagePath,
    this.isPassword = false,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: widget.isPassword && !_isPasswordVisible,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF333333),
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: Color(0x4D9B9B9B),
          fontSize: 16,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(widget.imagePath, width: 25, height: 25),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 65),
        suffixIcon: widget.isPassword
            ? Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            child: Image.asset(
              _isPasswordVisible
                  ? 'assets/img/ico_visibilidade_ativa.png'
                  : 'assets/img/ico_visibilidade.png',
              width: 25,
              height: 25,
            ),
          ),
        )
            : null,
        suffixIconConstraints: const BoxConstraints(minWidth: 65),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 21.0, horizontal: 20.0),
      ),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    );
  }
}
