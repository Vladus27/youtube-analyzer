import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';

class DialogVideoDetailsModalScreen extends StatelessWidget {
  const DialogVideoDetailsModalScreen({
    super.key,
    required this.titleVid,
    required this.authorVid,
    required this.originalText,
    required this.modifiedText,
  });
  final String titleVid;
  final String authorVid;
  final String originalText;
  final String modifiedText;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SizedBox(
        width: 700,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: 'Formated',
                  icon: Icon(Icons.format_align_center),
                ),
                Tab(
                  text: 'Original',
                  icon: Icon(Icons.text_fields),
                )
              ],
            ),
            title: Text('$authorVid — $titleVid'), 
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: Container(                  
                  color: const Color.fromARGB(255, 65, 0, 72),
                  child:  Padding(
                    padding:const EdgeInsets.all(16),
                    child:  MarkdownBody(                      
                        data: modifiedText,
                        //  "# Ключові Думки Відео \n## Ситуація на Східному Фронті:\n- **Інтенсивні Бої:** Найбільш напружена обстановка спостерігається на Покровському, Лиманському та Сіверському напрямках.\n- **Покровський Напрямок:** Епіцентр російських атак, характеризується безперервними штурмами.\n- **Лиманський Напрямок:** Залишається стратегічно важливим для російських військ з метою подальшої окупації Донецької області.\n- **Торецьк:** Місто потерпає від тривалих боїв, що тривають вже дев'ять місяців.\n- **Курський Напрямок:** Українські сили успішно стримують спроби просування російських військ до державного кордону.\n## Відповідь на Агресію та Наслідки:\n- **Удар по Курщині:** Україна завдала удару по російських військових об'єктах у Курській області у відповідь на ракетну атаку по Сумах.\n- **Ракетний Удар по Сумах:** Відео містить розповіді очевидців та інформацію про ліквідацію наслідків російського ракетного удару по місту.\n- **Втрата Житла:** Розглядається історія жінки, яка втратила свій дім внаслідок атаки дрона, та процедура отримання компенсації за зруйноване майно.\n## Міжнародна Підтримка:\n- **Візит Генсека НАТО:** У відео згадується важливість міжнародної підтримки України, зокрема візит Генерального секретаря НАТО, що підкреслює солідарність та допомогу.\n"
                            ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: const Color.fromARGB(255, 72, 1, 63),
                  child: Text(originalText == ''
                      ? 'original text is coming soon'
                      : originalText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
