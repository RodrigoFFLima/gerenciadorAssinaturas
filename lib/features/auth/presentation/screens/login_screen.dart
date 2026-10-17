import 'package:flutter/material.dart';

import '../../../dashboard/presentation/screens/home_shell.dart';

const _ink = Color(0xFF171D32);
const _muted = Color(0xFF52556B);
const _violet = Color(0xFF4328F0);
const _lavender = Color(0xFFF1F1FF);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _registering = false;
  bool _rememberMe = true;
  bool _personalProfile = true;
  bool _showPassword = false;
  String _currency = 'R\$ Real (BRL)';

  void _enterApp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const HomeShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth >= 900) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(flex: 11, child: _heroPanel()),
                        Expanded(flex: 10, child: _formPanel()),
                      ],
                    );
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        _heroPanel(compact: true),
                        _formPanel(compact: true),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 600;
    final stacked = width < 900;
    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: compact ? 16 : 28),
      decoration: const BoxDecoration(
        color: Color(0xFFFCFBFF),
        border: Border(bottom: BorderSide(color: Color(0xFFE9E8F6))),
      ),
      child: Row(
        children: [
          _BrandLockup(compact: stacked),
          const Spacer(),
          if (!compact)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF0FF),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Row(
                children: [
                  Icon(Icons.circle, color: Color(0xFF00845A), size: 10),
                  SizedBox(width: 8),
                  Text(
                    'Ambiente Seguro',
                    style: TextStyle(color: _ink, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _heroPanel({bool compact = false}) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF0EFFF), Color(0xFFF5F5FF), Color(0xFFE0FFF5)],
          stops: [0, 0.68, 1],
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          compact ? 24 : 72,
          compact ? 28 : 68,
          compact ? 24 : 72,
          30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!compact)
              Row(
                children: [
                  const _BrandMark(size: 48),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SubTrack',
                        style: TextStyle(
                          color: _ink,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Gestão Inteligente de Assinaturas',
                        style: TextStyle(
                          color: _muted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (!compact)
                    _pill(
                      icon: Icons.verified_user_outlined,
                      label: 'Balanço 100% Auditável',
                      foreground: const Color(0xFF087E62),
                      background: Colors.white.withValues(alpha: 0.8),
                    ),
                ],
              ),
            SizedBox(height: compact ? 34 : 82),
            _pill(
              icon: Icons.circle,
              label: 'Detecção de Gastos Invisíveis em Tempo Real',
              foreground: _violet,
              background: const Color(0xFFE9E9FF),
            ),
            const SizedBox(height: 28),
            Text.rich(
              TextSpan(
                style: TextStyle(
                  color: _ink,
                  fontSize: compact ? 34 : 46,
                  height: 1.13,
                  fontWeight: FontWeight.w800,
                ),
                children: const [
                  TextSpan(text: 'Controle absoluto de cada assinatura '),
                  TextSpan(
                    text: 'antes que a fatura chegue.',
                    style: TextStyle(color: _violet),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Monitore gastos recorrentes, receba alertas de vencimento inteligentes e descubra serviços duplicados ou esquecidos em segundos.',
              style: TextStyle(color: _muted, fontSize: 17, height: 1.55),
            ),
            const SizedBox(height: 26),
            _monthlyPreview(),
            const SizedBox(height: 28),
            const Wrap(
              spacing: 26,
              runSpacing: 12,
              children: [
                _TrustNote(
                  icon: Icons.people_alt_outlined,
                  text: 'Mais de R\$ 1.2M em assinaturas\ngerenciadas.',
                ),
                _TrustNote(
                  icon: Icons.lock_outline_rounded,
                  text: 'Criptografia de nível bancário\nAES-256',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _monthlyPreview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF26324D).withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: _violet, size: 20),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Visão Recorrente Mensal',
                  style: TextStyle(
                    color: _ink,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
              ),
              _pill(
                label: 'Economia: R\$ 658,00/ano',
                foreground: const Color(0xFF073B2B),
                background: const Color(0xFF64F0B4),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF0FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.notifications_active_outlined,
                  color: Color(0xFF8D4A15),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Netflix Premium 4K',
                        style: TextStyle(
                          color: _ink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Cobrança programada em 2 dias',
                        style: TextStyle(color: _muted, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Text(
                  'R\$ 55,90',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Limite mensal orçado (R\$ 1.800,00)',
                  style: TextStyle(color: _muted, fontSize: 13),
                ),
              ),
              Text(
                '76% comprometido',
                style: TextStyle(color: _violet, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: const LinearProgressIndicator(
              value: 0.76,
              minHeight: 10,
              backgroundColor: Color(0xFFE9E9FF),
              color: _violet,
            ),
          ),
          const SizedBox(height: 16),
          const Wrap(
            spacing: 18,
            runSpacing: 8,
            alignment: WrapAlignment.spaceBetween,
            children: [
              _DotLabel(color: _violet, label: '14 ativas'),
              _DotLabel(
                color: Color(0xFF007C59),
                label: '3 cancelamentos pendentes',
              ),
              Text(
                'Total: R\$ 1.368,00/mês',
                style: TextStyle(
                  color: _ink,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _formPanel({bool compact = false}) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        compact ? 24 : 72,
        compact ? 36 : 80,
        compact ? 24 : 72,
        36,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (compact) ...[
                Text(
                  _registering ? 'Crie sua conta' : 'Acesse sua conta',
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Retome o controle financeiro do seu mês',
                  style: TextStyle(color: _muted, fontSize: 16),
                ),
                const SizedBox(height: 16),
                _modeSwitch(),
              ] else
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _registering
                                ? 'Crie sua conta'
                                : 'Acesse sua conta',
                            style: const TextStyle(
                              color: _ink,
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Retome o controle financeiro do seu mês',
                            style: TextStyle(color: _muted, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    _modeSwitch(),
                  ],
                ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: _socialButton('Google', Icons.g_mobiledata_rounded),
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: _socialButton('Apple', Icons.apple)),
                ],
              ),
              const SizedBox(height: 28),
              const Row(
                children: [
                  Expanded(child: Divider(color: Color(0xFFE4E4F0))),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OU COM SEU E-MAIL',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Color(0xFFE4E4F0))),
                ],
              ),
              const SizedBox(height: 24),
              _inputField(
                'E-mail de Acesso',
                hint: 'seu.nome@exemplo.com',
                icon: Icons.mail_outline_rounded,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Senha de Acesso',
                      style: TextStyle(
                        color: _ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Esqueceu a senha?'),
                  ),
                ],
              ),
              TextField(
                obscureText: !_showPassword,
                decoration:
                    _inputDecoration(
                      '••••••••••••',
                      Icons.lock_outline_rounded,
                    ).copyWith(
                      suffixIcon: IconButton(
                        onPressed: () =>
                            setState(() => _showPassword = !_showPassword),
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: _muted,
                        ),
                      ),
                    ),
              ),
              const SizedBox(height: 18),
              _profileSettings(),
              const SizedBox(height: 14),
              CheckboxListTile(
                value: _rememberMe,
                onChanged: (value) =>
                    setState(() => _rememberMe = value ?? false),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text(
                  'Permanecer conectado por 30 dias',
                  style: TextStyle(color: _muted, fontSize: 14),
                ),
                activeColor: _violet,
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 58,
                child: FilledButton.icon(
                  onPressed: _enterApp,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text(
                    _registering
                        ? 'Criar conta SubTrack'
                        : 'Acessar Plataforma SubTrack',
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: _violet,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 3,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const Text.rich(
                TextSpan(
                  style: TextStyle(color: _muted, fontSize: 13),
                  children: [
                    TextSpan(text: 'Não tem uma assinatura ainda? '),
                    TextSpan(
                      text: 'Experimente 14 dias grátis',
                      style: TextStyle(
                        color: _violet,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Ao prosseguir, você concorda com nossos Termos de Serviço e Política de Privacidade LGPD.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF777A8D),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _modeSwitch() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFE9E9FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _modeButton(
            'Entrar',
            !_registering,
            () => setState(() => _registering = false),
          ),
          _modeButton(
            'Criar Conta',
            _registering,
            () => setState(() => _registering = true),
          ),
        ],
      ),
    );
  }

  Widget _modeButton(String label, bool selected, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: selected ? Colors.white : Colors.transparent,
        foregroundColor: selected ? _violet : _muted,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      ),
      child: Text(label),
    );
  }

  Widget _socialButton(String label, IconData icon) {
    return OutlinedButton.icon(
      onPressed: _enterApp,
      icon: Icon(icon, size: 22),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color(0xFFF3F3FF),
        foregroundColor: _ink,
        side: BorderSide.none,
        minimumSize: const Size.fromHeight(58),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _inputField(
    String label, {
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            label,
            style: const TextStyle(color: _ink, fontWeight: FontWeight.w700),
          ),
        ),
        TextField(decoration: _inputDecoration(hint, icon)),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF85869A)),
      prefixIcon: Icon(icon, color: _muted),
      filled: true,
      fillColor: _lavender,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _violet, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    );
  }

  Widget _profileSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _lavender,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tune_rounded, color: _violet, size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'CONFIGURAÇÃO RÁPIDA DO PERFIL',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                'Pré-definido',
                style: TextStyle(
                  color: Color(0xFF00845A),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Finalidade Principal:',
            style: TextStyle(color: _ink, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _profileButton(
                  'Pessoal / Família',
                  Icons.person_outline_rounded,
                  true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _profileButton(
                  'PJ / Freelancer',
                  Icons.business_outlined,
                  false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Moeda Padrão de Análise:',
                  style: TextStyle(color: _muted, fontWeight: FontWeight.w600),
                ),
              ),
              DropdownButton<String>(
                value: _currency,
                underline: const SizedBox.shrink(),
                items: const [
                  DropdownMenuItem(
                    value: 'R\$ Real (BRL)',
                    child: Text('R\$ Real (BRL)'),
                  ),
                  DropdownMenuItem(
                    value: 'US\$ Dólar (USD)',
                    child: Text('US\$ Dólar (USD)'),
                  ),
                  DropdownMenuItem(
                    value: '€ Euro (EUR)',
                    child: Text('€ Euro (EUR)'),
                  ),
                ],
                onChanged: (value) =>
                    setState(() => _currency = value ?? _currency),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _profileButton(String label, IconData icon, bool personal) {
    final selected = _personalProfile == personal;
    return TextButton.icon(
      onPressed: () => setState(() => _personalProfile = personal),
      icon: Icon(icon, size: 17),
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      style: TextButton.styleFrom(
        backgroundColor: selected ? Colors.white : Colors.transparent,
        foregroundColor: selected ? _violet : _muted,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      ),
    );
  }
}

class _BrandLockup extends StatelessWidget {
  const _BrandLockup({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _BrandMark(size: 48),
        const SizedBox(width: 11),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'SubTrack',
              style: TextStyle(
                color: _ink,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              compact
                  ? 'Gestão Inteligente de Assinaturas'
                  : 'GESTÃO RECORRENTE',
              style: const TextStyle(
                color: _muted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _violet,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(
        Icons.account_balance_wallet_outlined,
        color: Colors.white,
      ),
    );
  }
}

Widget _pill({
  required String label,
  required Color foreground,
  required Color background,
  IconData? icon,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: foreground),
          const SizedBox(width: 6),
        ],
        Text(
          label,
          style: TextStyle(
            color: foreground,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

class _TrustNote extends StatelessWidget {
  const _TrustNote({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xFF00845A), size: 19),
        const SizedBox(width: 9),
        Text(
          text,
          style: const TextStyle(
            color: _muted,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _DotLabel extends StatelessWidget {
  const _DotLabel({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, color: color, size: 10),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: _muted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
