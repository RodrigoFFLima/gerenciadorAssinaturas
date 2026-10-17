import 'package:flutter_test/flutter_test.dart';
import 'package:gerenciador_assinaturas/main.dart';

void main() {
  testWidgets('app renders the SubTrack welcome and navigation shell', (tester) async {
    await tester.pumpWidget(const SubTrackApp());

    expect(find.text('SubTrack'), findsWidgets);
    expect(find.text('Gestão Inteligente de Assinaturas'), findsOneWidget);
  });
}
