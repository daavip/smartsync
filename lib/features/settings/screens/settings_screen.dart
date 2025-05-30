import 'package:flutter/material.dart';
import '../widgets/setting_option.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SettingOption(
            icon: Icons.notifications,
            title: 'Notificações',
            subtitle: 'Configurar alertas e notificações',
          ),
          SettingOption(
            icon: Icons.palette,
            title: 'Tema',
            subtitle: 'Escolha entre tema claro ou escuro',
          ),
          SettingOption(
            icon: Icons.security,
            title: 'Privacidade',
            subtitle: 'Configurações de segurança',
          ),
          SettingOption(
            icon: Icons.help,
            title: 'Ajuda e Suporte',
            subtitle: 'Central de ajuda e contato',
          ),
          SettingOption(
            icon: Icons.info,
            title: 'Sobre o aplicativo',
            subtitle: 'Versão e informações',
          ),
        ],
      ),
    );
  }
}