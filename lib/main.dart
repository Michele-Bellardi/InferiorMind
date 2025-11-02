import 'package:flutter/material.dart';
import 'dart:math';

//prova comemnto

void main() {
  runApp(const MasterMindApp());
}

class MasterMindApp extends StatelessWidget {
  const MasterMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Master Mind Semplificato',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MasterMindGame(),
    );
  }
}

class MasterMindGame extends StatefulWidget {
  const MasterMindGame({super.key});

  @override
  State<MasterMindGame> createState() => _MasterMindGameState();
}

class _MasterMindGameState extends State<MasterMindGame> {
  // Colori disponibili per il gioco
  final List<Color> availableColors = [
    Colors.grey,  // 0 - Stato iniziale
    Colors.red,    // 1
    Colors.blue,   // 2
    Colors.green,  // 3
    Colors.yellow, // 4
    Colors.purple, // 5
  ];


  List<int> secretCode = [];


  List<int> currentSequence = [0, 0, 0, 0];

  // Risultato del tentativo
  String resultMessage = 'Premi i bottoni per iniziare!';
  bool showDebug = true; // Per vedere il codice segreto durante lo sviluppo

  @override
  void initState() {
    super.initState();
    _generateSecretCode();
  }

  // Genera il codice segreto casuale
  void _generateSecretCode() {
    final random = Random();
    secretCode = List.generate(4, (_) => random.nextInt(5) + 1); //genero codice segreto
    print('CODICE SEGRETO: $secretCode'); // Per debug
  }

  // Cambia il colore di un bottone
  void _changeColor(int index) {
    setState(() {
      currentSequence[index] = (currentSequence[index] + 1) % availableColors.length;
      if (currentSequence[index] == 0) currentSequence[index] = 1; // Salta il grigio
      resultMessage = 'Sequenza: $currentSequence';
    });
  }

  // Verifica la sequenza del giocatore
  void _checkSequence() {
    print(' Verifica in corso...');
    print('Codice segreto: $secretCode');
    print(' Sequenza giocatore: $currentSequence');

    // Controlla che tutti i colori siano selezionati
    if (currentSequence.contains(0)) {
      setState(() {
        resultMessage = ' Completa tutti i 4 colori prima di verificare!';
      });
      return;
    }

    int correctPosition = 0;
    int correctColor = 0;

    // Lista per tenere traccia dei colori già contati
    List<bool> secretUsed = List.filled(4, false);
    List<bool> currentUsed = List.filled(4, false);

    //  trova le posizioni esatte
    for (int i = 0; i < 4; i++) {
      if (currentSequence[i] == secretCode[i]) {
        correctPosition++;
        secretUsed[i] = true;
        currentUsed[i] = true;
      }
    }

    //  trova colori giusti ma posizione sbagliata
    for (int i = 0; i < 4; i++) {
      if (!currentUsed[i]) { // Se questa posizione non è già stata contata come esatta
        for (int j = 0; j < 4; j++) {
          if (!secretUsed[j] && // Se questo colore segreto non è già stato usato
              !currentUsed[i] && // E questa posizione corrente non è stata usata
              currentSequence[i] == secretCode[j]) {
            correctColor++;
            secretUsed[j] = true;
            currentUsed[i] = true;
            break; // Esci dal ciclo interno una volta trovata una corrispondenza
          }
        }
      }
    }

    setState(() {
      if (correctPosition == 4) {
        resultMessage = ' COMPLIMENTI! HAI VINTO! \n'
            'Hai indovinato tutte e 4 le posizioni!';
      } else {
        resultMessage = 'Risultato:\n'
            ' Posizioni corrette: $correctPosition\n'
            'Colori giusti (posizione sbagliata): $correctColor\n'
            '\nClicca i cerchi per cambiare colori e riprova!';
      }
    });

    print(' Risultato: $correctPosition posizioni corrette, $correctColor colori giusti');
  }

  // Resetta il gioco
  void _resetGame() {
    setState(() {
      _generateSecretCode();
      currentSequence = [0, 0, 0, 0];
      resultMessage = 'Gioco resettato! Crea una nuova sequenza.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Master Mind Semplificato'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
            tooltip: 'Reset Gioco',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Titolo
            const Text(
              'Indovina la sequenza di 4 colori!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            // Debug: mostra il codice segreto (solo durante lo sviluppo)
            if (showDebug) ...[
              const SizedBox(height: 10),
              Card(
                color: Colors.orange[100],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Text(
                        'DEBUG (solo sviluppo):',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Codice segreto: $secretCode',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        'La tua sequenza: $currentSequence',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Bottoni dei colori
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return GestureDetector(
                  onTap: () => _changeColor(index),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: availableColors[currentSequence[index]],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: currentSequence[index] == 0
                        ? const Icon(Icons.add, color: Colors.white, size: 30)
                        : null,
                  ),
                );
              }),
            ),

            const SizedBox(height: 30),

            // Bottone di verifica
            ElevatedButton(
              onPressed: _checkSequence,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: const Text('VERIFICA SEQUENZA'),
            ),

            const SizedBox(height: 20),

            // Bottone reset
            ElevatedButton(
              onPressed: _resetGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('RESET GIOCO'),
            ),

            const SizedBox(height: 20),

            // Risultato
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blueGrey),
              ),
              child: Text(
                resultMessage,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}