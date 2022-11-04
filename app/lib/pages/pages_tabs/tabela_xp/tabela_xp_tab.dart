import 'package:app/components/custom_shimer.dart';
import 'package:app/pages/pages_tabs/heighscore/components/category_tile.dart';
import 'package:app/services/utils_services.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/pages_tabs/tabela_xp/components/controllers/form_controller.dart';
import 'package:app/pages/pages_tabs/tabela_xp/components/models/form.dart';

class TabelaXpTab extends StatefulWidget {
  const TabelaXpTab({super.key});

  @override
  State<TabelaXpTab> createState() => _TabelaXpTabState();
}

class _TabelaXpTabState extends State<TabelaXpTab> {
  UtilsServices utilsServices = UtilsServices();

  List<TableForm> tableFormRuby = [];

  bool isLoading = true;

  static const String urlRuby =
      "https://script.googleusercontent.com/macros/echo?user_content_key=cSRt3-Zhi5a-vMXGi34--LOXjIpSCzoXD-SZvAh7v0oKwqc2l3AWDnx9-_uw6atxGFPqmAY8lGEiT3s7TSUg6XpF1SF9-3gem5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnAEboqpeURwTe2iAMY9OKwts61oxJtqaoMhQvPOIoVr_Hbgam9CA55F48oCJDR1cw4JC5_V28AznUIPm1vCWsQJFvnZ3JX3SHg&lib=MWIoGiHUETa7SEH7VmUDtOYVkjUvmgrU1";

  static const String urlOnix =
      "https://script.googleusercontent.com/macros/echo?user_content_key=HogpfWb1rXPSYJXnjPHdrFlxiCVAdL9zT4XTWkhjilj0mnG9THFmbaN3aipGaXMOp-v7vLBXfd7rK8t_0TQv7vpaf52lrdxem5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnByITFT4i_VORboaUDFIOzBfan9_at7t9-5OsMqkEsgeRFrlvLWr7g2CYjM8QYKKPtLsn9MhMO9ohCWhoklrJAOPbaIMJt6cmQ&lib=MMa_N4VA9Xn7f-jj2V96E4OYAV6orcnYB";

  @override
  void initState() {
    super.initState();

    FormController().getTableList(urlRuby).then((tableForm) {
      setState(() {
        tableFormRuby = tableForm;
        isLoading = false;
      });
    });
  }

  // -------------------------------------------------------- PAGE

  List<String> categories = [
    'Ruby',
    'Onix',
  ];

  String selectCategory = 'Ruby';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //---------------------------------------------------------------------- categories
          Container(
            padding: const EdgeInsets.only(left: 100),
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, index) {
                return const SizedBox(
                  width: 50,
                );
              },
              itemBuilder: (_, index) {
                return CategorieTile(
                  category: categories[index],
                  isSelected: categories[index] == selectCategory,
                  onPressed: () {
                    setState(() {
                      selectCategory = categories[index];
                    });

                    if (selectCategory == 'Onix') {
                      isLoading = true;
                      FormController().getTableList(urlOnix).then((tableForm) {
                        setState(() {
                          tableFormRuby = tableForm;
                          isLoading = false;
                        });
                      });
                    }

                    if (selectCategory == 'Ruby') {
                      isLoading = true;
                      FormController().getTableList(urlRuby).then((tableForm) {
                        setState(() {
                          tableFormRuby = tableForm;
                          isLoading = false;
                        });
                      });
                    }
                  },
                );
              },
            ),
          ),
          //----------------------------------------------------------------------
          Expanded(
            child: !isLoading
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(12),
                    itemCount: tableFormRuby.length,
                    itemBuilder: ((context, index) {
                      final player = tableFormRuby[index];

                      return InkWell(
                        onTap: () {},
                        child: Column(
                          children: [
                            Card(
                              color: index == 0 ? Colors.green : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 5,
                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                              child: ListTile(
                                dense: index == 0 ? false : true,
                                leading: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, left: 10),
                                  child: Text(
                                    (index + 1).toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: index == 0
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  player.nome,
                                  style: TextStyle(
                                    fontSize: index == 0 ? 20 : 15,
                                    fontWeight: FontWeight.bold,
                                    color: index == 0
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                subtitle: Text(
                                  '(${player.classe})',
                                  style: TextStyle(
                                    color: index == 0
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                trailing: Text(
                                  utilsServices.priceToCurrency(
                                      double.parse(player.ganhoDeExp)),
                                  style: TextStyle(
                                    fontSize: index == 0 ? 20 : 16,
                                    fontWeight: FontWeight.w500,
                                    color: index == 0
                                        ? Colors.white
                                        : double.parse(player.ganhoDeExp) < 0
                                            ? Colors.red
                                            : Colors.green,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  )
                : ListView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(12),
                    children: List.generate(
                      10,
                      (index) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: CustomShimmer(
                          height: 60,
                          width: 50,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
