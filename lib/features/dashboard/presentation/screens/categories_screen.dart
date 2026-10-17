import 'package:flutter/material.dart';

import '../../../subscriptions/data/mock_data.dart';

const _ink = Color(0xFF171D32);
const _muted = Color(0xFF73758A);
const _violet = Color(0xFF4328F0);
const _lavender = Color(0xFFF2F1FF);

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<CategoryBudget> _categories = List.of(categoryBudgets);
  bool _annual = false;

  @override
  Widget build(BuildContext context) {
    final total = _categories.fold<double>(0, (sum, category) => sum + category.amount);
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 1100 ? 3 : constraints.maxWidth >= 680 ? 2 : 1;
            const spacing = 14.0;
            final cardWidth = (constraints.maxWidth - 40 - spacing * (columns - 1)) / columns;
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
              children: [
                _heading(),
                const SizedBox(height: 18),
                _summary(total),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(child: Text('Categorias Detalhadas', style: TextStyle(color: _ink, fontSize: 17, fontWeight: FontWeight.w800))),
                    Icon(Icons.sort_rounded, color: _muted, size: 16),
                    SizedBox(width: 5),
                    Text('Ordenado por maior despesa', style: TextStyle(color: _muted, fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: _categories
                      .map((category) => SizedBox(width: cardWidth, child: _categoryCard(category)))
                      .toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _heading() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 720;
        const title = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Eyebrow(text: 'INTELIGÊNCIA FINANCEIRA  •  CICLO ATUAL'),
            SizedBox(height: 6),
            Text('Controle de Gastos por Categoria', style: TextStyle(color: _ink, fontSize: 25, height: 1.1, fontWeight: FontWeight.w800)),
            SizedBox(height: 5),
            Text('Entenda exatamente para onde vai o seu dinheiro em assinaturas mensais e anuais. Compare o impacto acumulado por segmento.', style: TextStyle(color: _muted, fontSize: 11, height: 1.4)),
          ],
        );
        final actions = Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: compact ? WrapAlignment.start : WrapAlignment.end,
          children: [
            _outlinedAction(Icons.calendar_month_outlined, 'Maio 2025'),
            _periodSelector(),
            FilledButton.icon(
              onPressed: _addCategory,
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text('Nova Categoria'),
              style: FilledButton.styleFrom(backgroundColor: _violet, foregroundColor: Colors.white, textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9))),
            ),
          ],
        );
        if (compact) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [title, const SizedBox(height: 14), actions]);
        }
        return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [const Expanded(child: title), const SizedBox(width: 18), Flexible(child: actions)]);
      },
    );
  }

  Widget _periodSelector() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(color: _lavender, borderRadius: BorderRadius.circular(9)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _periodButton('Mensal', !_annual, () => setState(() => _annual = false)),
          _periodButton('Projeção Anual', _annual, () => setState(() => _annual = true)),
        ],
      ),
    );
  }

  Widget _periodButton(String label, bool selected, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: selected ? Colors.white : Colors.transparent,
        foregroundColor: selected ? _violet : _muted,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        minimumSize: const Size(0, 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
    );
  }

  Widget _summary(double total) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFEDECF4)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final content = Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Eyebrow(text: 'TOTAL ACUMULADO EM CATEGORIAS'),
                    const SizedBox(height: 7),
                    Text('R\$ ${(total * (_annual ? 12 : 1)).toStringAsFixed(2)}', style: const TextStyle(color: _ink, fontSize: 29, fontWeight: FontWeight.w800)),
                    Text(_annual ? 'projeção anual' : '/ mês', style: const TextStyle(color: _muted, fontSize: 10)),
                    const SizedBox(height: 7),
                    Text('Média: R\$ ${(total / _categories.length).toStringAsFixed(2)} por categoria  •  ${_categories.length} segmentos monitorados', style: const TextStyle(color: _muted, fontSize: 10)),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(flex: 6, child: _distributionSummary()),
            ],
          );
          if (constraints.maxWidth < 650) {
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [content.children[0], const SizedBox(height: 18), content.children[2]]);
          }
          return content;
        },
      ),
    );
  }

  Widget _distributionSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Expanded(child: Text('Distribuição de Impacto Orçamentário', style: TextStyle(color: _muted, fontSize: 10, fontWeight: FontWeight.w600))),
            Text('100% categorizado', style: TextStyle(color: _ink, fontSize: 9, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 8,
            child: Row(children: _categories.map((item) => Expanded(flex: item.percent.round(), child: ColoredBox(color: item.tint))).toList()),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 5,
          children: _categories.map((item) => _LegendDot(label: '${item.name.split(' ').first} (${item.percent.toStringAsFixed(1)}%)', color: item.tint)).toList(),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: _lavender, borderRadius: BorderRadius.circular(9)),
          child: const Row(
            children: [
              Icon(Icons.auto_awesome, color: _violet, size: 15),
              SizedBox(width: 7),
              Expanded(child: Text('Dica da MVP: Streaming representa 28% do orçamento. Veja oportunidades de otimização.', style: TextStyle(color: _muted, fontSize: 10))),
              Icon(Icons.arrow_forward_rounded, color: _violet, size: 14),
            ],
          ),
        ),
      ],
    );
  }

  Widget _categoryCard(CategoryBudget category) {
    final amount = category.amount * (_annual ? 12 : 1);
    final cap = category.name.contains('Produtividade') ? 200.0 : 120.0;
    final progress = (category.amount / cap).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFEDECF4))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 32, height: 32, decoration: BoxDecoration(color: category.tint.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(9)), child: Icon(_iconFor(category.name), color: category.tint, size: 17)),
              const SizedBox(width: 8),
              Expanded(child: Text(category.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: _ink, fontSize: 12, fontWeight: FontWeight.w800))),
              _Tag(label: '${category.percent.toStringAsFixed(1)}%', color: category.tint, background: category.tint.withValues(alpha: 0.12)),
            ],
          ),
          const SizedBox(height: 3),
          Padding(padding: const EdgeInsets.only(left: 40), child: Text('${category.services.length} assinaturas ativas', style: const TextStyle(color: _muted, fontSize: 9))),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: _lavender, borderRadius: BorderRadius.circular(9)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(_annual ? 'PROJEÇÃO ANUAL' : 'SUBTOTAL MENSAL', style: const TextStyle(color: _muted, fontSize: 8, fontWeight: FontWeight.w800, letterSpacing: 0.4))),
                    Text(_annual ? 'Anual' : 'Meta: R\$ ${cap.toStringAsFixed(2)}', style: const TextStyle(color: _muted, fontSize: 8)),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: Text('R\$ ${amount.toStringAsFixed(2)}', style: const TextStyle(color: _ink, fontSize: 23, fontWeight: FontWeight.w800))),
                    Text(_annual ? 'ano' : 'Dentro do teto', style: const TextStyle(color: Color(0xFF087E62), fontSize: 8, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LinearProgressIndicator(value: progress, minHeight: 4, color: category.tint, backgroundColor: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 13),
          const Text('SERVIÇOS NO GRUPO', style: TextStyle(color: _muted, fontSize: 8, fontWeight: FontWeight.w800, letterSpacing: 0.4)),
          const SizedBox(height: 5),
          ...category.services.map((service) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Container(width: 23, height: 23, alignment: Alignment.center, decoration: BoxDecoration(color: category.tint.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(7)), child: Text(service.characters.first, style: TextStyle(color: category.tint, fontSize: 9, fontWeight: FontWeight.w800))),
                    const SizedBox(width: 7),
                    Expanded(child: Text(service, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: _ink, fontSize: 10, fontWeight: FontWeight.w600))),
                    Text('R\$ ${(category.amount / category.services.length).toStringAsFixed(2)}', style: const TextStyle(color: _ink, fontSize: 9, fontWeight: FontWeight.w700)),
                  ],
                ),
              )),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFECEBF5)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Expanded(child: Text('Próximo débito: 14/05', style: TextStyle(color: _muted, fontSize: 9))),
              TextButton(onPressed: () {}, style: TextButton.styleFrom(foregroundColor: _violet, padding: EdgeInsets.zero, minimumSize: const Size(0, 24), textStyle: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700)), child: const Text('Gerenciar')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _outlinedAction(IconData icon, String label) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 14),
      label: Text(label),
      style: OutlinedButton.styleFrom(foregroundColor: _ink, side: const BorderSide(color: Color(0xFFE2E1F0)), padding: const EdgeInsets.symmetric(horizontal: 10), textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
    );
  }

  IconData _iconFor(String name) {
    if (name.contains('Filmes')) return Icons.movie_outlined;
    if (name.contains('Produtividade')) return Icons.psychology_alt_outlined;
    if (name.contains('Música')) return Icons.headphones_rounded;
    if (name.contains('Jogos')) return Icons.sports_esports_outlined;
    return Icons.cloud_outlined;
  }

  Future<void> _addCategory() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova categoria'),
        content: TextField(controller: controller, autofocus: true, decoration: const InputDecoration(labelText: 'Nome da categoria')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text('Adicionar')),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.isEmpty) return;
    setState(() {
      _categories.add(CategoryBudget(name: name, amount: 0, percent: 0, services: const [], tint: _violet));
    });
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(color: _muted, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.5));
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, color: color, size: 7),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(color: _muted, fontSize: 8)),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color, required this.background});

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.w800)),
    );
  }
}