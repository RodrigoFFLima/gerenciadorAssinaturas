import 'package:flutter/material.dart';

import 'calendar_screen.dart';
import 'categories_screen.dart';
import 'dashboard_screen.dart';
import 'subscriptions_screen.dart';

const _ink = Color(0xFF171D32);
const _muted = Color(0xFF73758A);
const _violet = Color(0xFF4328F0);
const _page = Color(0xFFFAFAFF);
const _lavender = Color(0xFFF2F1FF);

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  final List<_NavItem> _items = const [
    _NavItem('Dashboard / Visão Geral', Icons.grid_view_rounded),
    _NavItem('Minhas Assinaturas', Icons.credit_card_rounded),
    _NavItem('Categorias & Gastos', Icons.pie_chart_outline_rounded),
    _NavItem('Calendário de Vencimentos', Icons.calendar_month_outlined),
    _NavItem('Configurações', Icons.settings_outlined),
  ];

  final _subscriptionsKey = GlobalKey<SubscriptionsScreenState>();

  late final List<Widget> _pages = [
    DashboardScreen(),
    SubscriptionsScreen(key: _subscriptionsKey),
    const CategoriesScreen(),
    const CalendarScreen(),
    const _SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _page,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;
          if (wide) {
            return Row(
              children: [
                SizedBox(width: 210, child: _sidebar()),
                Expanded(
                  child: Column(
                    children: [
                      _topBar(compact: false),
                      Expanded(
                        child: IndexedStack(
                          index: _selectedIndex,
                          children: _pages,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              _topBar(compact: true),
              Expanded(
                child: IndexedStack(index: _selectedIndex, children: _pages),
              ),
              NavigationBar(
                selectedIndex: _selectedIndex,
                onDestinationSelected: (index) => setState(() => _selectedIndex = index),
                destinations: _items
                    .map(
                      (item) => NavigationDestination(
                        icon: Icon(item.icon),
                        label: item.mobileLabel,
                      ),
                    )
                    .toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _sidebar() {
    return Container(
      color: _lavender,
      padding: const EdgeInsets.fromLTRB(14, 20, 14, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 28),
            child: Row(
              children: [
                _BrandMark(),
                SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SubTrack', style: TextStyle(color: _ink, fontSize: 17, fontWeight: FontWeight.w800)),
                      Text('Finanças Recorrentes', style: TextStyle(color: _muted, fontSize: 10, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ...List.generate(_items.length, (index) {
            final item = _items[index];
            final selected = index == _selectedIndex;
            return Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Material(
                color: selected ? _violet : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () => setState(() => _selectedIndex = index),
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 11),
                    child: Row(
                      children: [
                        Icon(item.icon, size: 17, color: selected ? Colors.white : _muted),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            item.label,
                            style: TextStyle(
                              color: selected ? Colors.white : _ink,
                              fontSize: 12,
                              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text('ORÇAMENTO LIMITE', style: TextStyle(color: _muted, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.4))),
                    Text('76%', style: TextStyle(color: _violet, fontSize: 10, fontWeight: FontWeight.w800)),
                  ],
                ),
                SizedBox(height: 8),
                Text('Gasto Mensal:', style: TextStyle(color: _muted, fontSize: 10)),
                SizedBox(height: 2),
                Text('R\$ 384,90', style: TextStyle(color: _ink, fontSize: 16, fontWeight: FontWeight.w800)),
                SizedBox(height: 7),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  child: LinearProgressIndicator(value: 0.76, minHeight: 5, color: _violet, backgroundColor: _lavender),
                ),
                SizedBox(height: 7),
                Text('Meta: R\$ 500,00    Resta R\$ 115,10', style: TextStyle(color: _muted, fontSize: 9)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar({required bool compact}) {
    return Container(
      height: compact ? 64 : 72,
      padding: EdgeInsets.symmetric(horizontal: compact ? 14 : 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFECEBF5))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: _lavender, borderRadius: BorderRadius.circular(9)),
              child: const Row(
                children: [
                  Icon(Icons.search_rounded, color: _muted, size: 19),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar assinaturas, serviços...',
                        hintStyle: TextStyle(color: _muted, fontSize: 12),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      style: TextStyle(color: _ink, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!compact) ...[
            const SizedBox(width: 14),
            _topAction(Icons.calendar_month_outlined, 'Maio 2025'),
            const SizedBox(width: 12),
          ],
          const SizedBox(width: 10),
          FilledButton.icon(
            onPressed: _startAddSubscription,
            icon: const Icon(Icons.add_rounded, size: 17),
            label: Text(compact ? 'Nova' : 'Nova Assinatura'),
            style: FilledButton.styleFrom(
              backgroundColor: _violet,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: compact ? 11 : 14),
              minimumSize: Size(0, compact ? 38 : 40),
              textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
            ),
          ),
          if (!compact) ...[
            IconButton(
              onPressed: () {},
              tooltip: 'Notificações',
              icon: const Icon(Icons.notifications_none_rounded, color: _ink, size: 20),
            ),
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFE1E5F7),
              child: Text('LS', style: TextStyle(color: _violet, fontSize: 10, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(width: 8),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Lucas Silva', style: TextStyle(color: _ink, fontSize: 11, fontWeight: FontWeight.w700)),
                Text('Plano Pro', style: TextStyle(color: _muted, fontSize: 10)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _topAction(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      decoration: BoxDecoration(color: _lavender, borderRadius: BorderRadius.circular(9)),
      child: Row(
        children: [
          Icon(icon, color: _muted, size: 15),
          const SizedBox(width: 7),
          Text(label, style: const TextStyle(color: _ink, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _startAddSubscription() {
    setState(() => _selectedIndex = 1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _subscriptionsKey.currentState?.openAddForm();
    });
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 27,
      height: 27,
      decoration: BoxDecoration(color: _violet, borderRadius: BorderRadius.circular(7)),
      child: const Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 15),
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.icon);

  final String label;
  final IconData icon;

  String get mobileLabel {
    if (label.startsWith('Dashboard')) return 'Visão geral';
    if (label.startsWith('Minhas')) return 'Assinaturas';
    if (label.startsWith('Categorias')) return 'Categorias';
    if (label.startsWith('Calendário')) return 'Calendário';
    return 'Ajustes';
  }
}

class _SettingsScreen extends StatelessWidget {
  const _SettingsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _page,
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          const Text('CONFIGURAÇÕES DA CONTA', style: TextStyle(color: _muted, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
          const SizedBox(height: 6),
          const Text('Preferências', style: TextStyle(color: _ink, fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          const Text('Personalize sua experiência e os avisos financeiros.', style: TextStyle(color: _muted, fontSize: 11)),
          const SizedBox(height: 18),
          _SettingsGroup(
            title: 'Perfil e análise',
            icon: Icons.person_outline_rounded,
            children: const [
              _SettingsRow(title: 'Finalidade principal', value: 'Pessoal / Família', icon: Icons.people_outline_rounded),
              _SettingsRow(title: 'Moeda padrão', value: 'Real brasileiro (BRL)', icon: Icons.attach_money_rounded),
            ],
          ),
          const SizedBox(height: 12),
          _SettingsGroup(
            title: 'Notificações',
            icon: Icons.notifications_none_rounded,
            children: const [
              _SettingsRow(title: 'Alertas de vencimento', value: '2 dias antes', icon: Icons.event_available_outlined),
              _SettingsRow(title: 'Resumo mensal', value: 'Ativado', icon: Icons.summarize_outlined),
            ],
          ),
          const SizedBox(height: 12),
          _SettingsGroup(
            title: 'Segurança e plano',
            icon: Icons.shield_outlined,
            children: const [
              _SettingsRow(title: 'Criptografia', value: 'AES-256', icon: Icons.lock_outline_rounded),
              _SettingsRow(title: 'Assinatura SubTrack', value: 'Plano Pro', icon: Icons.workspace_premium_outlined),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.title, required this.icon, required this.children});

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFEDECF4))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, color: _violet, size: 17), const SizedBox(width: 8), Text(title, style: const TextStyle(color: _ink, fontSize: 12, fontWeight: FontWeight.w800))]),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.title, required this.value, required this.icon});

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon, color: _muted, size: 17),
        title: Text(title, style: const TextStyle(color: _ink, fontSize: 10, fontWeight: FontWeight.w600)),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [Text(value, style: const TextStyle(color: _muted, fontSize: 10)), const SizedBox(width: 8), const Icon(Icons.chevron_right_rounded, color: _muted, size: 16)]),
        onTap: () {},
      ),
    );
  }
}