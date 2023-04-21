import 'package:iconsax/iconsax.dart';
import 'package:todark/app/services/isar_service.dart';
import 'package:todark/app/widgets/todos_ce.dart';
import 'package:todark/app/widgets/todos_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllTaskPage extends StatefulWidget {
  const AllTaskPage({super.key});

  @override
  State<AllTaskPage> createState() => _AllTaskPageState();
}

class _AllTaskPageState extends State<AllTaskPage> {
  final service = IsarServices();

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 5, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'allTasks'.tr,
                      style: context.theme.textTheme.titleLarge?.copyWith(
                        color: Get.isDarkMode ? Colors.white : Colors.black,
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
                  thumbIcon: service.thumbIconTodo,
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
          Expanded(
            child: TodosList(
              calendare: false,
              allTask: true,
              toggle: service.toggleValue.value,
              set: () {
                getCountTodos();
              },
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
              return TodosCe(
                text: "create".tr,
                edit: false,
                category: true,
                set: () {
                  getCountTodos();
                },
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
