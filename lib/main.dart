import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lecture 5 · Counter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        fontFamily: 'Nunito',
      ),
      home: const CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key, this.title = '计数器 · 步长'});

  final String title;

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  // 这是页面需要跨 build 保留的数据，不要放进 build 的局部变量里。
  int _count = 0;
  int _step = 1;

  void _log(String event) {
    debugPrint('[CounterPage] $event | count=$_count step=$_step');
  }

  @override
  void initState() {
    super.initState();
    _log('initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _log('didChangeDependencies');
  }

  @override
  void didUpdateWidget(covariant CounterPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _log('didUpdateWidget: ${oldWidget.title} -> ${widget.title}');
  }

  @override
  void reassemble() {
    super.reassemble();
    _log('reassemble');
  }

  @override
  void deactivate() {
    _log('deactivate');
    super.deactivate();
  }

  @override
  void dispose() {
    _log('dispose');
    // 本例没有 Timer、订阅或控制器；添加这类资源后须在这里释放。
    super.dispose();
  }

  void _inc() {
    setState(() {
      _count += _step;
    });
    _log('increment');
  }

  void _selectStep(int step) {
    setState(() {
      _step = step;
    });
    _log('selectStep');
  }

  void _reset() {
    setState(() {
      _count = 0;
    });
    _log('reset');
  }

  @override
  Widget build(BuildContext context) {
    _log('build');
    // 两处 Theme.of：分别读取主题配色和文字样式。
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: colors.primaryContainer,
        foregroundColor: colors.onPrimaryContainer,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/study_desk.png',
                      key: const Key('study-image'),
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      semanticLabel: '书本、绿植与笔记本插画',
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('当前计数', style: textStyles.titleMedium),
                  Text(
                    '$_count',
                    key: const Key('count'),
                    style: textStyles.displayLarge?.copyWith(
                      color: colors.primary,
                      fontSize: 72,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('每次增加', style: textStyles.titleSmall),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      for (final step in const [1, 2, 5])
                        ChoiceChip(
                          label: Text('+$step'),
                          selected: _step == step,
                          onSelected: (_) => _selectStep(step),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('已选择步长 +$_step', style: textStyles.bodyMedium),
                  TextButton.icon(
                    onPressed: _reset,
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('归零'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: '增加计数',
        onPressed: _inc,
        child: const Icon(Icons.add),
      ),
    );
  }
}
