import 'package:todark/app/data/schema.dart';
import 'package:todark/app/services/isar_service.dart';
import 'package:todark/app/widgets/task_type_cu.dart';
import 'package:todark/app/widgets/todos_ce.dart';
import 'package:todark/app/widgets/todos_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({
    super.key,
    required this.task,
    required this.set,
  });
  final Tasks task;
  final Function() set;

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final service = IsarServices();
  int countTotalTodos = 0;
  int countDoneTodos = 0;

  @override
  void initState() {
    getCountTodos();
    super.initState();
  }

  getCountTodos() async {
    final countTotal = await service.getCountTotalTodosTask(widget.task);
    final countDone = await service.getCountDoneTodosTask(widget.task);
    setState(() {
      countTotalTodos = countTotal;
      countDoneTodos = countDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.set();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: context.theme.scaffoldBackgroundColor,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          titleSpacing: 0,
          leading: IconButton(
            onPressed: () {
              widget.set();
              Get.back();
            },
            icon: Icon(
              Iconsax.arrow_left_1,
              color: context.theme.iconTheme.color,
              size: 20,
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          title: widget.task.description.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.task.title,
                      style: context.theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.task.description,
                      style: context.theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )
              : Text(
                  widget.task.title,
                  style: context.theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  enableDrag: false,
                  backgroundColor: context.theme.scaffoldBackgroundColor,
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return TaskTypeCu(
                      text: 'editing'.tr,
                      edit: true,
                      task: widget.task,
                      set: () {
                        setState(() {});
                      },
                    );
                  },
                );
              },
              icon: Icon(
                Iconsax.edit,
                color: context.theme.iconTheme.color,
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, bottom: 5, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'tasks'.tr,
                                style: context.theme.textTheme.titleLarge
                                    ?.copyWith(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              Text(
                                '($countDoneTodos/$countTotalTodos) ${'completed'.tr}',
                                style:
                                    context.theme.textTheme.bodySmall?.copyWith(
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
                        allTask: false,
                        calendare: false,
                        toggle: service.toggleValue.value,
                        task: widget.task,
                        set: () {
                          getCountTodos();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
                  text: 'create'.tr,
                  edit: false,
                  task: widget.task,
                  category: false,
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
      ),
    );
  }
}
