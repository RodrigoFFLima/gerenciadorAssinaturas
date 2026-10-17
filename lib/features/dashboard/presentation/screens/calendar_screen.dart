import 'package:flutter/material.dart';

import '../../../subscriptions/data/mock_data.dart';
import '../../../subscriptions/models/subscription.dart';

const _ink = Color(0xFF171D32);
const _muted = Color(0xFF73758A);
const _violet = Color(0xFF4328F0);
const _lavender = Color(0xFFF2F1FF);

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _monthOffset = 0;
  String _view = 'Calendário Mensal';
  bool _alertsEnabled = true;

  DateTime get _month => DateTime(2025, 5 + _monthOffset);

  final Map<int, _CalendarEvent> _events = const {
    5: _CalendarEvent('ChatGPT', 109.90, Color(0xFF00845A)),
    10: _CalendarEvent('Google One', 19.90, Color(0xFF00845A)),
    14: _CalendarEvent('Netflix', 55.90, Color(0xFF9B6514)),
    17: _CalendarEvent('Prime', 19.90, _violet),
    20: _CalendarEvent('Spotify', 34.90, _violet),
    22: _CalendarEvent('Game Pass', 39.90, _violet),
    25: _CalendarEvent('Disney+', 34.90, _violet),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 1000;
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
              children: [
                _heading(wide),
                const SizedBox(height: 16),
                _summaryCards(wide),
                const SizedBox(height: 14),
                if (wide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 7, child: _calendarPanel()),
                      const SizedBox(width: 14),
                      Expanded(flex: 3, child: _rightPanel()),
                    ],
                  )
                else ...[
                  _calendarPanel(),
                  const SizedBox(height: 14),
                  _rightPanel(),
                ],
                const SizedBox(height: 14),
                _weeklyPanel(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _heading(bool wide) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 760;
        final title = const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Eyebrow(text: 'FLUXO FINANCEIRO & PREVISIBILIDADE  •  EXERCÍCIO 2025'),
            SizedBox(height: 6),
            Text('Calendário de Pagamentos', style: TextStyle(color: _ink, fontSize: 24, fontWeight: FontWeight.w800, height: 1.1)),
          ],
        );
        final actions = Wrap(
          spacing: 7,
          runSpacing: 7,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _monthPicker(),
            _viewSelector(),
            OutlinedButton.icon(
              onPressed: _exportCalendar,
              icon: const Icon(Icons.download_outlined, size: 14),
              label: const Text('Exportar .ICS'),
              style: OutlinedButton.styleFrom(foregroundColor: _ink, side: const BorderSide(color: Color(0xFFE2E1F0)), textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            ),
          ],
        );
        if (compact) return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [title, const SizedBox(height: 12), actions]);
        return Row(children: [Expanded(child: title), const SizedBox(width: 16), Flexible(child: actions)]);
      },
    );
  }

  Widget _monthPicker() {
    return Container(
      decoration: BoxDecoration(color: _lavender, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(onPressed: () => setState(() => _monthOffset--), icon: const Icon(Icons.chevron_left_rounded, size: 17), visualDensity: VisualDensity.compact, color: _muted),
          Text('${_monthName(_month.month)} ${_month.year}', style: const TextStyle(color: _ink, fontSize: 10, fontWeight: FontWeight.w700)),
          IconButton(onPressed: () => setState(() => _monthOffset++), icon: const Icon(Icons.chevron_right_rounded, size: 17), visualDensity: VisualDensity.compact, color: _muted),
        ],
      ),
    );
  }

  Widget _viewSelector() {
    const options = ['Calendário Mensal', 'Timeline / Lista', 'Previsão Semanal'];
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(color: _lavender, borderRadius: BorderRadius.circular(9)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((option) {
          final selected = _view == option;
          return TextButton(
            onPressed: () => setState(() => _view = option),
            style: TextButton.styleFrom(backgroundColor: selected ? Colors.white : Colors.transparent, foregroundColor: selected ? _violet : _muted, padding: const EdgeInsets.symmetric(horizontal: 8), minimumSize: const Size(0, 30), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))),
            child: Text(option, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700)),
          );
        }).toList(),
      ),
    );
  }

  Widget _summaryCards(bool wide) {
    const cards = [
      _SummaryCard(title: 'TOTAL PREVISTO NO MÊS', value: 'R\$ 384,90', note: '7 assinaturas  •  Fechamento da média mensal', icon: Icons.account_balance_wallet_outlined, accent: _violet),
      _SummaryCard(title: 'JÁ LIQUIDADOS / PAGOS', value: 'R\$ 144,80', note: '37,6% liquidado', icon: Icons.check_circle_outline_rounded, accent: Color(0xFF087E62)),
      _SummaryCard(title: 'PENDENTES & A VENCER', value: 'R\$ 240,10', note: '5 cobranças  •  Próxima em 24h: Netflix', icon: Icons.schedule_rounded, accent: Color(0xFF9B6514)),
    ];
    if (wide) {
      return Row(children: [for (var i = 0; i < cards.length; i++) ...[if (i > 0) const SizedBox(width: 10), Expanded(child: cards[i])]]);
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - 10) / 2;
        return Wrap(spacing: 10, runSpacing: 10, children: cards.map((card) => SizedBox(width: width, child: card)).toList());
      },
    );
  }

  Widget _calendarPanel() {
    return _Panel(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(child: Text('Grade do Mês', style: TextStyle(color: _ink, fontSize: 13, fontWeight: FontWeight.w800))),
              _Legend(color: const Color(0xFF087E62), label: 'Pago'),
              const SizedBox(width: 9),
              _Legend(color: const Color(0xFF9B6514), label: 'Vence Hoje'),
              const SizedBox(width: 9),
              _Legend(color: _violet, label: 'Previsto'),
            ],
          ),
          const SizedBox(height: 10),
          if (_view == 'Calendário Mensal') _monthGrid() else _timeline(),
        ],
      ),
    );
  }

  Widget _monthGrid() {
    final firstDay = DateTime(_month.year, _month.month, 1);
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final prevMonthDays = DateTime(_month.year, _month.month, 0).day;
    final leading = firstDay.weekday - 1;
    final cells = <Widget>[];
    const weekdays = ['SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SÁB', 'DOM'];
    cells.addAll(weekdays.map((day) => Container(alignment: Alignment.center, color: _lavender, child: Text(day, style: const TextStyle(color: _muted, fontSize: 8, fontWeight: FontWeight.w800)))));
    for (var index = 0; index < 35; index++) {
      final day = index - leading + 1;
      final inMonth = day >= 1 && day <= daysInMonth;
      final shownDay = day < 1 ? prevMonthDays + day : day > daysInMonth ? day - daysInMonth : day;
      final event = inMonth ? _events[day] : null;
      cells.add(_dayCell(shownDay, inMonth, event, day == 14 && _month.month == 5));
    }
    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 3,
      crossAxisSpacing: 3,
      childAspectRatio: 1.35,
      children: cells,
    );
  }

  Widget _dayCell(int day, bool inMonth, _CalendarEvent? event, bool today) {
    final background = today ? const Color(0xFFFFF4E6) : event != null ? _lavender : Colors.white;
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(7), border: Border.all(color: today ? const Color(0xFFEACB94) : const Color(0xFFF0EFF6))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(day.toString().padLeft(2, '0'), style: TextStyle(color: inMonth ? _ink : const Color(0xFFB8B8C4), fontSize: 8, fontWeight: FontWeight.w700))),
              if (event != null) Icon(Icons.circle, size: 5, color: event.color),
            ],
          ),
          if (event != null) ...[
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.85), borderRadius: BorderRadius.circular(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.service, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: event.color, fontSize: 7, fontWeight: FontWeight.w700)),
                  Text('R\$ ${event.amount.toStringAsFixed(2)}', maxLines: 1, style: TextStyle(color: event.color, fontSize: 7, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ],
          if (today) const Spacer(),
          if (today) const Text('Hoje', style: TextStyle(color: Color(0xFF9B6514), fontSize: 7, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _timeline() {
    return Column(children: mockSubscriptions.map(_timelineRow).toList());
  }

  Widget _timelineRow(Subscription item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: _lavender, borderRadius: BorderRadius.circular(9)),
      child: Row(
        children: [
          Container(width: 32, height: 32, alignment: Alignment.center, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: Icon(Icons.event_outlined, color: item.accentColor, size: 16)),
          const SizedBox(width: 9),
          Expanded(child: Text('${item.nextBillingDate}  •  ${item.name}', style: const TextStyle(color: _ink, fontSize: 10, fontWeight: FontWeight.w700))),
          Text('R\$ ${item.price.toStringAsFixed(2)}', style: const TextStyle(color: _ink, fontSize: 10, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _rightPanel() {
    return Column(
      children: [
        _Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                type: MaterialType.transparency,
                child: SwitchListTile(
                  value: _alertsEnabled,
                  onChanged: (value) => setState(() => _alertsEnabled = value),
                  contentPadding: EdgeInsets.zero,
                  activeThumbColor: _violet,
                  title: const Text('Alerta no Celular', style: TextStyle(color: _ink, fontSize: 11, fontWeight: FontWeight.w800)),
                  subtitle: const Text('Avisar 2 dias antes do vencimento', style: TextStyle(color: _muted, fontSize: 9)),
                  secondary: const Icon(Icons.notifications_active_outlined, color: _violet, size: 18),
                ),
              ),
              const Divider(height: 1, color: Color(0xFFECEBF5)),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Expanded(child: Text('Próximos Vencimentos', style: TextStyle(color: _ink, fontSize: 12, fontWeight: FontWeight.w800))),
                  const Text('SUBTOTAL\nR\$ 110,70', textAlign: TextAlign.end, style: TextStyle(color: _violet, fontSize: 8, fontWeight: FontWeight.w800)),
                ],
              ),
              const SizedBox(height: 9),
              ...mockSubscriptions.take(4).map(_upcomingRow),
              TextButton.icon(onPressed: () {}, icon: const Icon(Icons.arrow_forward_rounded, size: 13), label: const Text('Ver todas as 7 assinaturas do mês'), style: TextButton.styleFrom(foregroundColor: _violet, textStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700))),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _billingCyclePanel(),
      ],
    );
  }

  Widget _upcomingRow(Subscription item) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Container(width: 28, height: 28, alignment: Alignment.center, decoration: BoxDecoration(color: item.accentColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)), child: Icon(Icons.subscriptions_outlined, color: item.accentColor, size: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: _ink, fontSize: 9, fontWeight: FontWeight.w700)),
                Text(item.nextBillingDate, style: const TextStyle(color: _muted, fontSize: 8)),
              ],
            ),
          ),
          Text('R\$ ${item.price.toStringAsFixed(2)}', style: const TextStyle(color: _ink, fontSize: 9, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _billingCyclePanel() {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.credit_card_outlined, color: _violet, size: 16),
              SizedBox(width: 7),
              Expanded(child: Text('Ciclo das Faturas', style: TextStyle(color: _ink, fontSize: 11, fontWeight: FontWeight.w800))),
              Text('Conciliação', style: TextStyle(color: _muted, fontSize: 8)),
            ],
          ),
          const SizedBox(height: 10),
          _cycleCard('NU', 'Nubank Ultravioleta', 'Fatura Aberta', 'Fechamento 21 de Maio', 'Vencimento 28 de Maio', 'Total: R\$ 205,70', const Color(0xFF6B37C8)),
          const SizedBox(height: 8),
          _cycleCard('IN', 'Banco Inter Black', 'Fecha em 4 dias', 'Fechamento 24 de Maio', 'Vencimento 31 de Maio', '3 cobranças previstas', const Color(0xFFE96A27)),
        ],
      ),
    );
  }

  Widget _cycleCard(String initials, String title, String status, String line1, String line2, String footer, Color color) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(color: _lavender, borderRadius: BorderRadius.circular(9)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 24, height: 24, alignment: Alignment.center, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)), child: Text(initials, style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w800))),
              const SizedBox(width: 7),
              Expanded(child: Text(title, style: const TextStyle(color: _ink, fontSize: 9, fontWeight: FontWeight.w700))),
              _Tag(label: status, color: const Color(0xFF087E62), background: const Color(0xFFE4F8EE)),
            ],
          ),
          const SizedBox(height: 8),
          Row(children: [Expanded(child: Text(line1, style: const TextStyle(color: _muted, fontSize: 8))), Expanded(child: Text(line2, textAlign: TextAlign.end, style: const TextStyle(color: _muted, fontSize: 8)))]),
          const SizedBox(height: 6),
          Text(footer, style: const TextStyle(color: _ink, fontSize: 8, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _weeklyPanel() {
    const values = [0.58, 0.2, 0.32, 0.92, 0.56];
    return _Panel(
      child: Row(
        children: [
          Container(width: 34, height: 34, decoration: BoxDecoration(color: _lavender, borderRadius: BorderRadius.circular(9)), child: const Icon(Icons.bar_chart_rounded, color: _violet, size: 19)),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Concentração de Desembolso Semanal', style: TextStyle(color: _ink, fontSize: 11, fontWeight: FontWeight.w800)),
                Text('A semana concentra os débitos previstos para o ciclo.', style: TextStyle(color: _muted, fontSize: 9)),
              ],
            ),
          ),
          SizedBox(
            width: 190,
            height: 50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(values.length, (index) => Container(width: 23, height: 12 + values[index] * 32, decoration: BoxDecoration(color: index == 2 ? const Color(0xFF9B6514) : _violet, borderRadius: const BorderRadius.vertical(top: Radius.circular(3))))),
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(int month) => const ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'][month - 1];

  void _exportCalendar() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exportação .ICS disponível em uma próxima etapa.')));
  }
}

class _CalendarEvent {
  const _CalendarEvent(this.service, this.amount, this.color);

  final String service;
  final double amount;
  final Color color;
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child, this.padding = const EdgeInsets.all(12)});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFEDECF4))),
      child: child,
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.title, required this.value, required this.note, required this.icon, required this.accent});

  final String title;
  final String value;
  final String note;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 98),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(11), border: Border.all(color: const Color(0xFFEDECF4))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Expanded(child: Text(title, style: const TextStyle(color: _muted, fontSize: 8, fontWeight: FontWeight.w800, letterSpacing: 0.3))), Icon(icon, color: accent, size: 15)]),
          const SizedBox(height: 9),
          Text(value, style: TextStyle(color: accent == _violet ? _ink : accent, fontSize: 21, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(note, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: _muted, fontSize: 8)),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.circle, color: color, size: 6), const SizedBox(width: 4), Text(label, style: const TextStyle(color: _muted, fontSize: 8))]);
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(color: _muted, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.5));
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color, required this.background});

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4), decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(20)), child: Text(label, style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.w800)));
}