import 'package:flutter/material.dart';

import '../models/subscription.dart';

final class CategoryBudget {
  const CategoryBudget({
    required this.name,
    required this.amount,
    required this.percent,
    required this.services,
    required this.tint,
  });

  final String name;
  final double amount;
  final double percent;
  final List<String> services;
  final Color tint;
}

final List<Subscription> mockSubscriptions = [
  const Subscription(
    name: 'Netflix Premium 4K',
    category: 'Filmes & Séries',
    provider: 'Nubank',
    cycle: 'Mensal',
    price: 55.90,
    nextBillingDate: '14/05/2025',
    status: 'Vence em 2 dias',
    accentColor: Color(0xFFE50914),
    cardAlias: '•••• 8912',
    description: 'Cobrança programada em 2 dias',
  ),
  const Subscription(
    name: 'Spotify Premium Duo',
    category: 'Música',
    provider: 'Visa',
    cycle: 'Mensal',
    price: 34.90,
    nextBillingDate: '20/05/2025',
    status: 'Ativa',
    accentColor: Color(0xFF1ED760),
    cardAlias: '•••• 4021',
    description: 'Planejamento de áudio e podcasts',
  ),
  const Subscription(
    name: 'ChatGPT Plus',
    category: 'Produtividade & IA',
    provider: 'Mastercard',
    cycle: 'Mensal',
    price: 109.90,
    nextBillingDate: '22/05/2025',
    status: 'Ativa',
    accentColor: Color(0xFF74AA9C),
    cardAlias: '•••• 1127',
    description: 'Assistente de IA e geração de conteúdo',
  ),
  const Subscription(
    name: 'Xbox Game Pass Ultimate',
    category: 'Jogos & Entretenimento',
    provider: 'Itaú',
    cycle: 'Mensal',
    price: 39.90,
    nextBillingDate: '28/05/2025',
    status: 'Ativa',
    accentColor: Color(0xFF107C10),
    cardAlias: '•••• 9234',
    description: 'Biblioteca e jogos em nuvem',
  ),
  const Subscription(
    name: 'Google One 2 TB',
    category: 'Nuvem & Armazenamento',
    provider: 'Visa',
    cycle: 'Mensal',
    price: 19.90,
    nextBillingDate: '17/05/2025',
    status: 'Ativa',
    accentColor: Color(0xFF4285F4),
    cardAlias: '•••• 2086',
    description: 'Armazenamento e backup do ecossistema',
  ),
];

final List<CategoryBudget> categoryBudgets = [
  const CategoryBudget(
    name: 'Filmes & Séries',
    amount: 110.70,
    percent: 28.8,
    services: ['Netflix 4K', 'Prime Video', 'Disney+'],
    tint: Color(0xFFB91C1C),
  ),
  const CategoryBudget(
    name: 'Produtividade & IA',
    amount: 144.90,
    percent: 37.6,
    services: ['ChatGPT Plus', 'Notion Pro', 'Figma'],
    tint: Color(0xFF2563EB),
  ),
  const CategoryBudget(
    name: 'Música & Áudio',
    amount: 33.40,
    percent: 8.7,
    services: ['Spotify Premium', 'YouTube Premium'],
    tint: Color(0xFF22C55E),
  ),
  const CategoryBudget(
    name: 'Jogos & Entretenimento',
    amount: 39.90,
    percent: 10.3,
    services: ['Xbox Game Pass', 'EA Play'],
    tint: Color(0xFF7C3AED),
  ),
  const CategoryBudget(
    name: 'Nuvem & Armazenamento',
    amount: 56.80,
    percent: 14.8,
    services: ['Google One', 'iCloud'],
    tint: Color(0xFFF59E0B),
  ),
];

final List<Map<String, String>> calendarEvents = [
  {'day': 'Seg', 'value': '27'},
  {'day': 'Ter', 'value': '28'},
  {'day': 'Qua', 'value': '29'},
  {'day': 'Qui', 'value': '30'},
  {'day': 'Sex', 'value': '01'},
  {'day': 'Sáb', 'value': '02'},
  {'day': 'Dom', 'value': '03'},
];
