import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:todark/app/services/isar_service.dart';
import 'package:todark/app/widgets/task_type_cu.dart';
import 'package:todark/app/widgets/task_type_list.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final service = IsarServices();
  final locale = Get.locale;
  int countTotalTodos = 0;
  int countDoneTodos = 0;

  @override
  void initState() {
    getCountTodos();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  getCountTodos() async {
    final countTotal = await service.getCountTotalTodos();
    final countDone = await service.getCountDoneTodos();
    setState(() {
      countTotalTodos = countTotal;
      countDoneTodos = countDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 15, left: 15),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.primaryContainer,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      SleekCircularSlider(
                        appearance: CircularSliderAppearance(
                          animationEnabled: false,
                          angleRange: 360,
                          startAngle: 270,
                          size: 110,
                          infoProperties: InfoProperties(
                            modifier: (percentage) {
                              return countTotalTodos != 0
                                  ? '${((countDoneTodos / countTotalTodos) * 100).round()}%'
                                  : '0%';
                            },
                            mainLabelStyle: context.theme.textTheme.titleLarge,
                          ),
                          customColors: CustomSliderColors(
                            progressBarColors: <Color>[
                              Colors.blueAccent,
                              Colors.greenAccent,
                            ],
                            trackColor: context.theme.dividerColor,
                          ),
                          customWidths: CustomSliderWidths(
                            progressBarWidth: 7,
                            trackWidth: 3,
                            handlerSize: 0,
                            shadowWidth: 0,
                          ),
                        ),
                        min: 0,
                        max: countTotalTodos != 0
                            ? countTotalTodos.toDouble()
                            : 1,
                        initialValue: countDoneTodos.toDouble(),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Text(
                          'taskCompleted'.tr,
                          style: context.theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    DateFormat.MMMMd('${locale?.languageCode}').format(
                      DateTime.now(),
                    ),
                    style: context.theme.textTheme.titleSmall,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 10, bottom: 5, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'categories'.tr,
                            style: context.theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '($countDoneTodos/$countTotalTodos) ${'completed'.tr}',
                            style: context.theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        thumbIcon: service.thumbIconTask,
                        value: service.toggleValue.value,
                        onChanged: (value) {
                          setState(() {
                            service.toggleValue.value = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                TaskTypeList(
                  toggle: service.toggleValue.value,
                  set: () {
                    getCountTodos();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            enableDrag: false,
            backgroundColor: context.theme.scaffoldBackgroundColor,
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return TaskTypeCu(
                text: 'create'.tr,
                edit: false,
              );
            },
          );
        },
        backgroundColor: context.theme.colorScheme.tertiaryContainer,
        child: const Icon(
          Iconsax.add,
        ),
      ),
    );
  }
}
