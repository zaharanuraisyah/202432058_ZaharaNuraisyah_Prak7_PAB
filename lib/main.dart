import 'package:flutter/material.dart';

void main() {
  runApp(const DompetkuApp());
}

// ============================================================
// 1. APLIKASI DAN TEMA
// ============================================================

class DompetkuApp extends StatelessWidget {
  const DompetkuApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF008577);
    const backgroundColor = Color(0xFFF3F9F7);

    return MaterialApp(
      title: 'Dompetku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: backgroundColor,
          foregroundColor: Color(0xFF263238),
          elevation: 0,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: backgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colors.grey.shade200,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: primaryColor,
              width: 1.5,
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF9CEFE1),
          foregroundColor: Color(0xFF164E49),
          elevation: 3,
        ),
      ),
      home: const DashboardPage(),
    );
  }
}

// ============================================================
// 2. MODEL KATEGORI
// ============================================================

class Category {
  const Category(this.name, this.imagePath);

  final String name;
  final String imagePath;
}

const List<Category> categories = [
  Category('Makanan', 'assets/images/makanan.png'),
  Category('Transportasi', 'assets/images/transportasi.png'),
  Category('Belanja', 'assets/images/belanja.png'),
  Category('Hiburan', 'assets/images/hiburan.png'),
  Category('Kesehatan', 'assets/images/kesehatan.jpg'),
];

// ============================================================
// 3. MODEL TRANSAKSI
// ============================================================

class Expense {
  Expense(this.title, this.amount, this.category);

  final String title;
  final double amount;
  final Category category;
}

// ============================================================
// 4. FORMAT RUPIAH
// ============================================================

String formatRupiah(double value) {
  final digits = value.toStringAsFixed(0);
  final buffer = StringBuffer();

  for (var i = 0; i < digits.length; i++) {
    final remaining = digits.length - i;

    buffer.write(digits[i]);

    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write('.');
    }
  }

  return 'Rp $buffer';
}

// ============================================================
// 5. DASHBOARD UTAMA
// ============================================================

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Expense> _expenses = [
    Expense('Makan Siang', 25000, categories[0]),
    Expense('Ojek ke Kampus', 15000, categories[1]),
    Expense('Beli Buku', 85000, categories[2]),
    Expense('Nonton Bioskop', 50000, categories[3]),
    Expense('Kopi Susu', 18000, categories[0]),
  ];

  double get _total {
    return _expenses.fold<double>(
      0,
      (sum, expense) => sum + expense.amount,
    );
  }

  Future<void> _openForm() async {
    final result = await Navigator.push<Expense>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddTransactionPage(),
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      _expenses.add(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Dompetku',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          bottom: const TabBar(
            isScrollable: false,
            tabs: [
              Tab(
                icon: Icon(Icons.receipt_long_outlined),
                text: 'Transaksi',
              ),
              Tab(
                icon: Icon(Icons.category_outlined),
                text: 'Kategori',
              ),
              Tab(
                icon: Icon(Icons.bar_chart_rounded),
                text: 'Statistik',
              ),
              Tab(
                icon: Icon(Icons.person_outline_rounded),
                text: 'Profil',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TransaksiTab(
              expenses: _expenses,
              total: _total,
            ),
            KategoriTab(
              expenses: _expenses,
            ),
            StatistikTab(
              expenses: _expenses,
            ),
            const ProfilTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _openForm,
          tooltip: 'Tambah transaksi',
          child: const Icon(
            Icons.add_rounded,
            size: 30,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 6. TAB TRANSAKSI
// ============================================================

class TransaksiTab extends StatelessWidget {
  const TransaksiTab({
    super.key,
    required this.expenses,
    required this.total,
  });

  final List<Expense> expenses;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(16, 18, 16, 16),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF9CEFE1),
                Color(0xFF73DDCC),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 30,
                  color: Color(0xFF17665D),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Pengeluaran',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF285C56),
                      ),
                    ),
                    const SizedBox(height: 5),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        formatRupiah(total),
                        style: const TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF164E49),
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${expenses.length} transaksi tercatat',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF285C56),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: expenses.isEmpty
              ? const Center(
                  child: Text('Belum ada transaksi.'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    0,
                    16,
                    100,
                  ),
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];

                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        leading: Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F7F5),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Image.asset(
                            expense.category.imagePath,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.image_not_supported_outlined,
                              );
                            },
                          ),
                        ),
                        title: Text(
                          expense.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(expense.category.name),
                        ),
                        trailing: Text(
                          formatRupiah(expense.amount),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// ============================================================
// 7. TAB KATEGORI: GRIDVIEW.BUILDER, DUA KOLOM
// ============================================================

class KategoriTab extends StatelessWidget {
  const KategoriTab({
    super.key,
    required this.expenses,
  });

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 100),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.90,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];

        final items = expenses
            .where(
              (expense) => expense.category.name == category.name,
            )
            .toList();

        final subtotal = items.fold<double>(
          0,
          (sum, expense) => sum + expense.amount,
        );

        return Card(
          margin: EdgeInsets.zero,
          elevation: 1,
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 82,
                  width: double.infinity,
                  child: Image.asset(
                    category.imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.medical_services_outlined,
                        size: 42,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  category.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${items.length} transaksi',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    formatRupiah(subtotal),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// 8. TAB STATISTIK
// ============================================================

class StatistikTab extends StatelessWidget {
  const StatistikTab({
    super.key,
    required this.expenses,
  });

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    final total = expenses.fold<double>(
      0,
      (sum, expense) => sum + expense.amount,
    );

    final largestExpense = expenses.isEmpty
        ? null
        : expenses.reduce(
            (a, b) => a.amount >= b.amount ? a : b,
          );

    final categoryTotals = categories.map((category) {
      final amount = expenses
          .where(
            (expense) => expense.category.name == category.name,
          )
          .fold<double>(
            0,
            (sum, expense) => sum + expense.amount,
          );

      return MapEntry(category, amount);
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 100),
      children: [
        const Text(
          'Ringkasan Keuangan',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Kenali pola pengeluaranmu dengan mudah.',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 22),

        // KARTU TOTAL PENGELUARAN
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF008577),
                Color(0xFF4DB6AC),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.white,
                  size: 27,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Total Pengeluaran',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 6),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  formatRupiah(total),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '${expenses.length} transaksi tercatat',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // JUMLAH TRANSAKSI DAN KATEGORI
        Row(
          children: [
            Expanded(
              child: _StatInfoCard(
                icon: Icons.receipt_long_outlined,
                title: 'Transaksi',
                value: '${expenses.length}',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatInfoCard(
                icon: Icons.category_outlined,
                title: 'Kategori',
                value: '${categories.length}',
              ),
            ),
          ],
        ),

        const SizedBox(height: 26),

        // TRANSAKSI TERBESAR
        const Text(
          'Transaksi Terbesar',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: largestExpense == null
                ? const Text('Belum ada transaksi.')
                : Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.trending_up_rounded,
                          color: Color(0xFFEF8B2C),
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              largestExpense.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              largestExpense.category.name,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              formatRupiah(largestExpense.amount),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),

        const SizedBox(height: 26),

        // PENGELUARAN PER KATEGORI
        const Text(
          'Pengeluaran per Kategori',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Perbandingan nominal setiap kategori.',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 18),

        ...categoryTotals.map((entry) {
          final amount = entry.value;
          final proportion = total == 0 ? 0.0 : amount / total;

          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.key.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      formatRupiah(amount),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: proportion,
                    minHeight: 9,
                    backgroundColor: const Color(0xFFE4EFEC),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${(proportion * 100).toStringAsFixed(1)}% dari total pengeluaran',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

// KOMPONEN KARTU INFORMASI STATISTIK

class _StatInfoCard extends StatelessWidget {
  const _StatInfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 26,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 9. TAB PROFIL ZAHARA NURAISYAH
// ============================================================

class ProfilTab extends StatelessWidget {
  const ProfilTab({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 100),
      children: [
        const Text(
          'Profil Saya',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Informasi mahasiswa',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 22),

        // KARTU PROFIL
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 28,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFB2DFDB),
                Color(0xFFE0F2F1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const CircleAvatar(
                  radius: 54,
                  backgroundImage: AssetImage(
                    'assets/images/avatar.png',
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Zahara Nuraisyah',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF164E49),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Mahasiswa Sistem Informasi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF356B65),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 17,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'NIM 202432058',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF164E49),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 26),

        const Text(
          'Informasi Akademik',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              ListTile(
                leading: Icon(
                  Icons.badge_outlined,
                  color: primaryColor,
                ),
                title: const Text('Nama Lengkap'),
                subtitle: const Text('Zahara Nuraisyah'),
              ),
              const Divider(height: 1, indent: 70),
              ListTile(
                leading: Icon(
                  Icons.numbers_rounded,
                  color: primaryColor,
                ),
                title: const Text('Nomor Induk Mahasiswa'),
                subtitle: const Text('202432058'),
              ),
              const Divider(height: 1, indent: 70),
              ListTile(
                leading: Icon(
                  Icons.school_outlined,
                  color: primaryColor,
                ),
                title: const Text('Program Studi'),
                subtitle: const Text('Sistem Informasi'),
              ),
              const Divider(height: 1, indent: 70),
              ListTile(
                leading: Icon(
                  Icons.account_balance_outlined,
                  color: primaryColor,
                ),
                title: const Text('Perguruan Tinggi'),
                subtitle: const Text('Institut Teknologi PLN'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 22),

        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                color: primaryColor,
                size: 30,
              ),
              const SizedBox(height: 10),
              const Text(
                'Dompetku',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Aplikasi pencatatan pengeluaran pribadi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Praktikum Pemrograman Aplikasi Bergerak',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================
// 10. FORM TAMBAH TRANSAKSI
// ============================================================

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  Category _selectedCategory = categories.first;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(
      _amountController.text.trim(),
    );

    final expense = Expense(
      _titleController.text.trim(),
      amount,
      _selectedCategory,
    );

    Navigator.pop(context, expense);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Transaksi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2F1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.edit_note_rounded,
                    size: 38,
                    color: Color(0xFF008577),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Catat Pengeluaran',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF164E49),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Masukkan detail transaksi yang ingin kamu catat.',
                    style: TextStyle(
                      color: Color(0xFF356B65),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            const Text(
              'Nama Transaksi',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 9),

            TextFormField(
              controller: _titleController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Contoh: Makan siang',
                prefixIcon: Icon(Icons.receipt_long_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama transaksi wajib diisi.';
                }

                return null;
              },
            ),

            const SizedBox(height: 20),

            const Text(
              'Nominal Pengeluaran',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 9),

            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Contoh: 25000',
                prefixIcon: Icon(Icons.payments_outlined),
                helperText: 'Masukkan nominal tanpa titik atau koma.',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nominal wajib diisi.';
                }

                final amount = double.tryParse(value.trim());

                if (amount == null || amount <= 0) {
                  return 'Nominal harus berupa angka lebih dari 0.';
                }

                return null;
              },
            ),

            const SizedBox(height: 20),

            const Text(
              'Kategori',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 9),

            DropdownButtonFormField<Category>(
              initialValue: _selectedCategory,
              isExpanded: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: [
                for (final category in categories)
                  DropdownMenuItem<Category>(
                    value: category,
                    child: Row(
                      children: [
                        Image.asset(
                          category.imagePath,
                          width: 30,
                          height: 30,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.medical_services_outlined,
                              size: 30,
                            );
                          },
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(category.name),
                        ),
                      ],
                    ),
                  ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 54,
              child: FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text(
                  'Simpan Transaksi',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}