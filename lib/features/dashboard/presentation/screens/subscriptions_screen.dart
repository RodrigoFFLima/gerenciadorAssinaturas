import 'package:flutter/material.dart';

import '../../../subscriptions/data/mock_data.dart';
import '../../../subscriptions/models/subscription.dart';

const _ink = Color(0xFF171D32);
const _muted = Color(0xFF73758A);
const _violet = Color(0xFF4328F0);
const _lavender = Color(0xFFF2F1FF);

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  SubscriptionsScreenState createState() => SubscriptionsScreenState();
}

class SubscriptionsScreenState extends State<SubscriptionsScreen> {
  final List<Subscription> _subscriptions = List.of(mockSubscriptions);
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Todas';
  String _query = '';

  Future<void> openAddForm() async {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final result = wide
        ? await showGeneralDialog<Map<String, dynamic>>(
            context: context,
            barrierDismissible: true,
            barrierLabel: 'Nova assinatura',
            barrierColor: const Color(0x99171D32),
            transitionDuration: const Duration(milliseconds: 220),
            pageBuilder: (context, animation, secondaryAnimation) {
              return Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 430,
                  height: double.infinity,
                  child: Material(
                    color: Colors.white,
                    child: _AddSubscriptionForm(onClose: () => Navigator.pop(context)),
                  ),
                ),
              );
            },
            transitionBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(begin: const Offset(0.18, 0), end: Offset.zero).animate(animation),
                child: child,
              );
            },
          )
        : await showModalBottomSheet<Map<String, dynamic>>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            builder: (_) => _AddSubscriptionForm(onClose: () => Navigator.pop(context)),
          );

    if (result == null) return;
    final price = double.tryParse((result['price'] as String).replaceAll(',', '.')) ?? 0;
    final newItem = Subscription(
      name: result['name'] as String,
      category: result['category'] as String,
      provider: result['provider'] as String,
      cycle: result['cycle'] as String,
      price: price,
      nextBillingDate: result['nextBillingDate'] as String,
      status: 'Ativo',
      accentColor: _violet,
      cardAlias: '•••• 8912',
      description: 'Cobrança recorrente programada',
    );
    setState(() => _subscriptions.insert(0, newItem));
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _subscriptions.where((item) {
      final matchesSearch = _query.isEmpty || '${item.name} ${item.category} ${item.provider}'.toLowerCase().contains(_query.toLowerCase());
      final matchesFilter = _selectedFilter == 'Todas' || item.category.toLowerCase().contains(_selectedFilter.toLowerCase());
      return matchesSearch && matchesFilter;
    }).toList();
    final total = filtered.fold<double>(0, (sum, item) => sum + item.price);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 900;
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
              children: [
                _heading(wide),
                const SizedBox(height: 16),
                _overview(),
                const SizedBox(height: 14),
                _filters(),
                const SizedBox(height: 12),
                _search(),
                const SizedBox(height: 12),
                if (wide) _table(filtered) else ...filtered.map(_subscriptionCard),
                _totalFooter(filtered.length, total),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _heading(bool wide) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Eyebrow(text: 'FINANÇAS RECORRENTES  •  CADASTRO ATIVO'),
              SizedBox(height: 6),
              Text('Gerenciamento de Assinaturas', style: TextStyle(color: _ink, fontSize: 24, fontWeight: FontWeight.w800)),
              SizedBox(height: 4),
              Text('Controle pagamentos recorrentes, alertas e categorização orçamentária.', style: TextStyle(color: _muted, fontSize: 11)),
            ],
          ),
        ),
        if (wide)
          FilledButton.icon(
            onPressed: openAddForm,
            icon: const Icon(Icons.add_rounded, size: 16),
            label: const Text('Nova Assinatura'),
            style: FilledButton.styleFrom(backgroundColor: _violet, foregroundColor: Colors.white, textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9))),
          ),
      ],
    );
  }

  Widget _overview() {
    final monthly = _subscriptions.fold<double>(0, (sum, item) => sum + item.price);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _statusChip('Ativas (${_subscriptions.length})', const Color(0xFF087E62), const Color(0xFFE4F8EE)),
        _statusChip('Pendentes (0)', const Color(0xFF9B6514), const Color(0xFFFFF4D9)),
        _statusChip('Pausadas (0)', _muted, _lavender),
        _statusChip('Ciclo Corrente: Maio 2025', _muted, Colors.white),
        Text('R\$ ${monthly.toStringAsFixed(2)} / mês', style: const TextStyle(color: _violet, fontSize: 11, fontWeight: FontWeight.w800)),
      ],
    );
  }

  Widget _filters() {
    const labels = ['Todas', 'Filmes', 'Música', 'Produtividade', 'Jogos', 'Nuvem'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: labels.map((label) {
          final selected = label == _selectedFilter;
          final count = label == 'Todas' ? _subscriptions.length : _subscriptions.where((item) => item.category.toLowerCase().contains(label.toLowerCase())).length;
          return Padding(
            padding: const EdgeInsets.only(right: 7),
            child: ChoiceChip(
              label: Text('$label ($count)'),
              selected: selected,
              onSelected: (_) => setState(() => _selectedFilter = label),
              selectedColor: _violet,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(color: selected ? Colors.white : _muted, fontSize: 10, fontWeight: FontWeight.w700),
              side: BorderSide(color: selected ? _violet : const Color(0xFFE8E7F1)),
              showCheckmark: false,
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _search() {
    return Container(
      height: 42,
      constraints: const BoxConstraints(maxWidth: 430),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(9), border: Border.all(color: const Color(0xFFE8E7F1))),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: _muted, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
              decoration: const InputDecoration(hintText: 'Buscar por nome, cartão ou categoria...', hintStyle: TextStyle(color: _muted, fontSize: 11), border: InputBorder.none, isDense: true),
              style: const TextStyle(color: _ink, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _table(List<Subscription> items) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE8E7F1))),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            color: _lavender,
            child: const Row(
              children: [
                Expanded(flex: 3, child: _TableHeading('SERVIÇO & PLANO')),
                Expanded(flex: 2, child: _TableHeading('CATEGORIA')),
                Expanded(child: _TableHeading('CICLO')),
                Expanded(flex: 2, child: _TableHeading('PRÓXIMO VENCIMENTO')),
                Expanded(child: _TableHeading('VALOR')),
                Expanded(flex: 2, child: _TableHeading('PAGAMENTO')),
                Expanded(child: _TableHeading('STATUS')),
                SizedBox(width: 50, child: _TableHeading('AÇÕES')),
              ],
            ),
          ),
          for (final item in items) _tableRow(item),
          if (items.isEmpty)
            const Padding(padding: EdgeInsets.all(24), child: Text('Nenhuma assinatura encontrada.', style: TextStyle(color: _muted, fontSize: 12))),
        ],
      ),
    );
  }

  Widget _tableRow(Subscription item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF0EFF6)))),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                _serviceMark(item),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: _ink, fontSize: 10, fontWeight: FontWeight.w700)),
                      Text(item.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: _muted, fontSize: 8)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(flex: 2, child: _categoryPill(item)),
          Expanded(child: Text(item.cycle, style: const TextStyle(color: _ink, fontSize: 9))),
          Expanded(flex: 2, child: Text('${item.nextBillingDate}\nEm breve', style: const TextStyle(color: _muted, fontSize: 9, height: 1.4))),
          Expanded(child: Text('R\$ ${item.price.toStringAsFixed(2)}', style: const TextStyle(color: _ink, fontSize: 10, fontWeight: FontWeight.w800))),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                const Icon(Icons.credit_card_outlined, color: _muted, size: 13),
                const SizedBox(width: 4),
                Expanded(child: Text('${item.provider}\n${item.cardAlias}', style: const TextStyle(color: _muted, fontSize: 8, height: 1.4))),
              ],
            ),
          ),
          Expanded(child: _statusChip('Ativo', const Color(0xFF087E62), const Color(0xFFE4F8EE))),
          SizedBox(
            width: 54,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: () {}, tooltip: 'Editar', icon: const Icon(Icons.edit_outlined, size: 13), visualDensity: VisualDensity.compact, padding: EdgeInsets.zero, constraints: const BoxConstraints.tightFor(width: 25, height: 25), color: _muted),
                IconButton(onPressed: () {}, tooltip: 'Pausar', icon: const Icon(Icons.pause_circle_outline, size: 13), visualDensity: VisualDensity.compact, padding: EdgeInsets.zero, constraints: const BoxConstraints.tightFor(width: 25, height: 25), color: _muted),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _subscriptionCard(Subscription item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE8E7F1))),
      child: Row(
        children: [
          _serviceMark(item),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(color: _ink, fontSize: 11, fontWeight: FontWeight.w700)),
                Text('${item.category}  •  ${item.cycle}  •  ${item.provider}', style: const TextStyle(color: _muted, fontSize: 9)),
                const SizedBox(height: 5),
                Text('Próximo vencimento: ${item.nextBillingDate}', style: const TextStyle(color: _muted, fontSize: 9)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('R\$ ${item.price.toStringAsFixed(2)}', style: const TextStyle(color: _ink, fontSize: 11, fontWeight: FontWeight.w800)),
              const SizedBox(height: 5),
              _statusChip('Ativo', const Color(0xFF087E62), const Color(0xFFE4F8EE)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _totalFooter(int count, double total) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: _lavender, borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10))),
      child: Row(
        children: [
          Expanded(child: Text('Exibindo $count assinaturas principais de ${_subscriptions.length} totais', style: const TextStyle(color: _muted, fontSize: 9))),
          const Text('TOTAL MENSAL FILTRADO: ', style: TextStyle(color: _muted, fontSize: 9, fontWeight: FontWeight.w700)),
          Text('R\$ ${total.toStringAsFixed(2)} / mês', style: const TextStyle(color: _violet, fontSize: 11, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _serviceMark(Subscription item) {
    return Container(
      width: 29,
      height: 29,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: item.accentColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
      child: Text(item.name.characters.first, style: TextStyle(color: item.accentColor, fontSize: 11, fontWeight: FontWeight.w800)),
    );
  }

  Widget _categoryPill(Subscription item) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        decoration: BoxDecoration(color: item.accentColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
        child: Text(item.category, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: item.accentColor, fontSize: 8, fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _statusChip(String label, Color color, Color background) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w700)),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _AddSubscriptionForm extends StatefulWidget {
  const _AddSubscriptionForm({required this.onClose});

  final VoidCallback onClose;

  @override
  State<_AddSubscriptionForm> createState() => _AddSubscriptionFormState();
}

class _AddSubscriptionFormState extends State<_AddSubscriptionForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController(text: '43,90');
  final _dateController = TextEditingController(text: '15/05/2025');
  String _category = 'Filmes & Séries';
  String _cycle = 'Mensal';
  String _provider = 'Cartão de Crédito Nubank (•••• 8912)';
  bool _reminder = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(18, 18, 12, 16),
            decoration: const BoxDecoration(color: _lavender, border: Border(bottom: BorderSide(color: Color(0xFFE8E7F1)))),
            child: Row(
              children: [
                Container(width: 34, height: 34, decoration: BoxDecoration(color: _violet, borderRadius: BorderRadius.circular(9)), child: const Icon(Icons.add_card_rounded, color: Colors.white, size: 18)),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nova Assinatura', style: TextStyle(color: _ink, fontSize: 16, fontWeight: FontWeight.w800)),
                      Text('Cadastre um serviço recorrente', style: TextStyle(color: _muted, fontSize: 10)),
                    ],
                  ),
                ),
                IconButton(onPressed: widget.onClose, tooltip: 'Fechar', icon: const Icon(Icons.close_rounded, color: _muted)),
              ],
            ),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  _label('Nome do Serviço'),
                  _textField(_nameController, hint: 'Disney+ Premium', icon: Icons.subscriptions_outlined),
                  const SizedBox(height: 14),
                  _label('Categoria de Custo'),
                  _dropdown(_category, ['Filmes & Séries', 'Música', 'Produtividade & IA', 'Jogos & Entretenimento', 'Nuvem & Armazenamento'], (value) => setState(() => _category = value)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_label('Valor (R\$)'), _textField(_priceController, hint: '43,90', icon: Icons.payments_outlined, keyboardType: TextInputType.number)])),
                      const SizedBox(width: 10),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_label('Ciclo de Cobrança'), _dropdown(_cycle, ['Mensal', 'Anual', 'Semanal'], (value) => setState(() => _cycle = value))])),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_label('Dia de Vencimento Recorrente'), _textField(_dateController, hint: '15/05/2025', icon: Icons.event_outlined)])),
                      const SizedBox(width: 10),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_label('Ciclo'), _dropdown('Todo mês', ['Todo mês', 'A cada 3 meses', 'Todo ano'], (_) {})])),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _label('Forma de Pagamento'),
                  _dropdown(_provider, ['Cartão de Crédito Nubank (•••• 8912)', 'Cartão Visa (•••• 4021)', 'Débito automático', 'Pix Programado'], (value) => setState(() => _provider = value)),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    value: _reminder,
                    onChanged: (value) => setState(() => _reminder = value),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    activeThumbColor: _violet,
                    title: const Text('Lembrar 3 dias antes', style: TextStyle(color: _ink, fontSize: 11, fontWeight: FontWeight.w700)),
                    subtitle: const Text('Notificação via WhatsApp & Push', style: TextStyle(color: _muted, fontSize: 9)),
                    secondary: const Icon(Icons.notifications_none_rounded, color: _violet, size: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: Color(0xFFE8E7F1))),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: _lavender, borderRadius: BorderRadius.circular(9)),
                    child: const Text('Esta assinatura será somada ao seu gasto previsto do mês. Você pode editar os dados depois.', style: TextStyle(color: _violet, fontSize: 10, height: 1.4)),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(color: _lavender, border: Border(top: BorderSide(color: Color(0xFFE8E7F1)))),
            child: Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: widget.onClose, child: const Text('Cancelar'))),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.check_rounded, size: 16),
                    label: const Text('Salvar Assinatura'),
                    style: FilledButton.styleFrom(backgroundColor: _violet, foregroundColor: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String label) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Text(label, style: const TextStyle(color: _ink, fontSize: 10, fontWeight: FontWeight.w700)));

  Widget _textField(TextEditingController controller, {required String hint, required IconData icon, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) => value == null || value.trim().isEmpty ? 'Campo obrigatório' : null,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: _muted, size: 16),
        filled: true,
        fillColor: _lavender,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: BorderSide.none),
      ),
      style: const TextStyle(color: _ink, fontSize: 11),
    );
  }

  Widget _dropdown(String value, List<String> values, ValueChanged<String> onChanged) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: _lavender,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: BorderSide.none),
      ),
      style: const TextStyle(color: _ink, fontSize: 10),
      items: values.map((item) => DropdownMenuItem(value: item, child: Text(item, maxLines: 1, overflow: TextOverflow.ellipsis))).toList(),
      onChanged: (next) {
        if (next != null) onChanged(next);
      },
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop({
      'name': _nameController.text.trim(),
      'category': _category,
      'provider': _provider,
      'cycle': _cycle,
      'price': _priceController.text.trim(),
      'nextBillingDate': _dateController.text.trim(),
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _dateController.dispose();
    super.dispose();
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(color: _muted, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.5));
}

class _TableHeading extends StatelessWidget {
  const _TableHeading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: _muted, fontSize: 8, fontWeight: FontWeight.w800));
}