import 'package:flutter/material.dart';

import '../../../subscriptions/data/mock_data.dart';
import '../../../subscriptions/models/subscription.dart';

const _ink = Color(0xFF171D32);
const _muted = Color(0xFF73758A);
const _violet = Color(0xFF4328F0);
const _lavender = Color(0xFFF2F1FF);

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final total = mockSubscriptions.fold<double>(
      0,
      (sum, item) => sum + item.price,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 980;
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
              children: [
                _pageHeading(wide),
                const SizedBox(height: 20),
                _metrics(wide),
                const SizedBox(height: 18),
                if (wide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 6, child: _categoryPanel(total)),
                      const SizedBox(width: 16),
                      Expanded(flex: 4, child: _upcomingPanel()),
                    ],
                  )
                else ...[
                  _categoryPanel(total),
                  const SizedBox(height: 16),
                  _upcomingPanel(),
                ],
                const SizedBox(height: 20),
                _recentSubscriptions(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _pageHeading(bool wide) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Eyebrow(text: 'PAINEL DE CONTROLE  •  TEMPO REAL'),
              SizedBox(height: 6),
              Text(
                'Visão Geral Financeira',
                style: TextStyle(
                  color: _ink,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Acompanhe seus gastos recorrentes, cadência e datas de vencimento em tempo real.',
                style: TextStyle(color: _muted, fontSize: 12),
              ),
            ],
          ),
        ),
        if (wide) ...[
          _smallAction(Icons.calendar_month_outlined, 'Maio 2025'),
          const SizedBox(width: 10),
          _smallAction(Icons.download_outlined, 'Exportar Relatório'),
        ],
      ],
    );
  }

  Widget _metrics(bool wide) {
    final metrics = <Widget>[
      const _MetricCard(
        title: 'COMPROMETIMENTO MENSAL',
        value: 'R\$ 384,90',
        detail: '↗ 5,2% vs. mês anterior',
        icon: Icons.account_balance_wallet_outlined,
        highlighted: true,
      ),
      const _MetricCard(
        title: 'ASSINATURAS ATIVAS',
        value: '11',
        detail: 'de 14 cadastradas  •  3 arquivadas',
        icon: Icons.verified_outlined,
        badge: '100% Em dia',
      ),
      const _MetricCard(
        title: 'VENCIMENTOS PRÓXIMOS (7D)',
        value: '3 faturas',
        detail: 'R\$ 89,70  •  Débitos programados',
        icon: Icons.event_available_outlined,
        badge: 'Atenção',
        badgeColor: Color(0xFFFFEDCD),
      ),
      const _MetricCard(
        title: 'MAIOR IMPACTO NO BOLSO',
        value: 'Produtividade & IA',
        detail: 'R\$ 145,00   (37,7%)',
        icon: Icons.psychology_alt_outlined,
      ),
    ];

    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < metrics.length; i++) ...[
            if (i > 0) const SizedBox(width: 12),
            Expanded(child: SizedBox(height: 142, child: metrics[i])),
          ],
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: metrics
              .map((card) => SizedBox(width: cardWidth, child: card))
              .toList(),
        );
      },
    );
  }

  Widget _categoryPanel(double total) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Distribuição de Gastos por Categoria',
            style: TextStyle(
              color: _ink,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'Visão percentual do teto mensal orçado',
            style: TextStyle(color: _muted, fontSize: 11),
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 8,
              child: Row(
                children: categoryBudgets.map((category) {
                  return Expanded(
                    flex: category.percent.round(),
                    child: ColoredBox(color: category.tint),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'R\$ 0,00',
                  style: TextStyle(color: _muted, fontSize: 10),
                ),
              ),
              Text(
                'Total Recorrente: R\$ ${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: _ink,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...categoryBudgets.map(
            (category) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: _lavender,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: category.tint.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _categoryIcon(category.name),
                        color: category.tint,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            style: const TextStyle(
                              color: _ink,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${category.services.length} serviços  •  ${category.services.join(', ')}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: _muted, fontSize: 9),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'R\$ ${category.amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: _ink,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '${category.percent.toStringAsFixed(1)}%',
                          style: const TextStyle(color: _muted, fontSize: 9),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _upcomingPanel() {
    final upcoming = mockSubscriptions.take(4).toList();
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Próximos Pagamentos',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _Tag(label: 'Maio', color: _violet, background: _lavender),
            ],
          ),
          const SizedBox(height: 3),
          const Text(
            'Prioridade para os próximos 10 dias',
            style: TextStyle(color: _muted, fontSize: 11),
          ),
          const SizedBox(height: 14),
          ...upcoming.map(_paymentRow),
          const SizedBox(height: 3),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.arrow_forward_rounded, size: 15),
            label: const Text('Ver Agenda Completa de Vencimentos'),
            style: TextButton.styleFrom(
              foregroundColor: _violet,
              textStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentRow(Subscription item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _lavender,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.name.characters.first,
                  style: TextStyle(
                    color: item.accentColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${item.provider} • ${item.cardAlias}',
                      style: const TextStyle(color: _muted, fontSize: 9),
                    ),
                  ],
                ),
              ),
              Text(
                'R\$ ${item.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: _ink,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Vence em ${item.nextBillingDate}',
                  style: const TextStyle(color: _muted, fontSize: 9),
                ),
              ),
              Text(
                item.status,
                style: TextStyle(
                  color: item.accentColor,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _recentSubscriptions() {
    return _Panel(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Assinaturas Recentes & Gerenciamento Rápido',
                    style: TextStyle(
                      color: _ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                _Tag(
                  label: 'Todas (${mockSubscriptions.length})',
                  color: _violet,
                  background: _lavender,
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFECEBF5)),
          for (final item in mockSubscriptions.take(5)) _subscriptionRow(item),
        ],
      ),
    );
  }

  Widget _subscriptionRow(Subscription item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: item.accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              item.name.characters.first,
              style: TextStyle(
                color: item.accentColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  item.category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 9),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              item.cycle,
              style: const TextStyle(color: _muted, fontSize: 10),
            ),
          ),
          Expanded(
            child: Text(
              'R\$ ${item.price.toStringAsFixed(2)}',
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: _ink,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 10),
          _Tag(
            label: item.status == 'Ativa' ? 'Ativo' : item.status,
            color: const Color(0xFF087E62),
            background: const Color(0xFFE4F8EE),
          ),
        ],
      ),
    );
  }

  Widget _smallAction(IconData icon, String text) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 15),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        foregroundColor: _ink,
        side: const BorderSide(color: Color(0xFFE2E1F0)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  IconData _categoryIcon(String name) {
    if (name.contains('Filmes')) return Icons.movie_outlined;
    if (name.contains('Produtividade')) return Icons.psychology_alt_outlined;
    if (name.contains('Música')) return Icons.headphones_rounded;
    if (name.contains('Jogos')) return Icons.sports_esports_outlined;
    return Icons.cloud_outlined;
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.detail,
    required this.icon,
    this.highlighted = false,
    this.badge,
    this.badgeColor = const Color(0xFFDDF8E9),
  });

  final String title;
  final String value;
  final String detail;
  final IconData icon;
  final bool highlighted;
  final String? badge;
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    final fg = highlighted ? Colors.white : _ink;
    return Container(
      constraints: const BoxConstraints(minHeight: 136),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: highlighted ? _violet : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: highlighted ? null : Border.all(color: const Color(0xFFEDECF4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  style: TextStyle(
                    color: highlighted ? Colors.white70 : _muted,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Icon(icon, color: highlighted ? Colors.white : _violet, size: 16),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: fg,
              fontSize: highlighted ? 25 : 18,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: Text(
                  detail,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: highlighted ? Colors.white70 : _muted,
                    fontSize: 9,
                  ),
                ),
              ),
              if (badge != null)
                _Tag(
                  label: badge!,
                  color: const Color(0xFF087E62),
                  background: badgeColor,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child, this.padding = const EdgeInsets.all(14)});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEDECF4)),
      ),
      child: child,
    );
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.circle, size: 7, color: Color(0xFF00845A)),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: _muted,
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 8,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
