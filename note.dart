{
  "id": 1,
  "email": "lukman@example.com",
  "karyawan_id": 101,
  "karyawan": {
    "id": 101,
    "nama_lengkap": "Lukman Hakim",
    "jabatan": "Senior Developer",
    "foto": "avatar.jpg"
  }
}

factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    karyawanId: json["karyawan_id"],
    email: json["email"],
    roleLevel: json["roleLevel"] ?? "Staff",
    
    // TAMBAHKAN LOGIKA INI:
    // Cek apakah key 'karyawan' ada dan tidak null
    karyawan: json["karyawan"] != null 
        ? Karyawan.fromJson(json["karyawan"]) 
        : null,
  );

  class Karyawan {
  int id;
  String namaLengkap;
  String? jabatan; // Bisa null
  String? foto;

  Karyawan({
    required this.id,
    required this.namaLengkap,
    this.jabatan,
    this.foto,
  });

  factory Karyawan.fromJson(Map<String, dynamic> json) => Karyawan(
    id: json["id"],
    // Sesuaikan key JSON dengan database kamu (misal: 'nama' atau 'nama_lengkap')
    namaLengkap: json["nama_lengkap"] ?? json["nama"] ?? "No Name", 
    jabatan: json["jabatan"],
    foto: json["foto"],
  );
}

serAccountsDrawerHeader(
  decoration: BoxDecoration(color: biru.withOpacity(0.8)),
  
  // LOGIKA TAMPILAN NAMA:
  // Jika loading -> "Loading..."
  // Jika ada data karyawan -> Tampilkan nama lengkap karyawan
  // Jika tidak ada data karyawan -> Tampilkan email sebagai cadangan
  accountName: isLoadingUser
      ? const Text("Loading...")
      : Text(
          currentUser?.karyawan?.namaLengkap ?? currentUser?.email ?? "User",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        
  accountEmail: Text(currentUser?.roleLevel ?? "Staff"),
  
  currentAccountPicture: CircleAvatar(
    // Logika Foto Profil (jika ada URL foto)
    backgroundImage: (currentUser?.karyawan?.foto != null)
        ? NetworkImage("https://url-website-kamu.com/storage/${currentUser!.karyawan!.foto}")
        : const AssetImage('assets/img/profile_placeholder.png') as ImageProvider,
  ),
),

class _MainScreenState extends State<MainScreen> {
  // ... variabel yang sudah ada (currentIndex, dll)
  
  // 1. Buat variabel untuk menampung data user
  User? currentUser;
  bool isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    // 2. Panggil fungsi fetch data saat layar dibuka
    fetchUserData();
  }

  void fetchUserData() async {
    AuthService authService = AuthService();
    User? user = await authService.getUserProfile();
    
    if (mounted) {
      setState(() {
        currentUser = user;
        isLoadingUser = false;
      });
    }
  }

  Future<User?> getUserProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        log("Token tidak ditemukan");
        return null;
      }

      // SESUAIKAN ENDPOINT INI dengan dokumentasi API kantormu
      // Biasanya: /api/v1/auth/me atau /api/v1/profile
      final url = Uri.parse('$baseUrl/api/v1/auth/me'); 
      
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      log("Get Profile Status: ${response.statusCode}");
      log("Get Profile Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        // Sesuaikan parsing ini dengan struktur JSON responsemru
        // Contoh jika JSON-nya: { "status": "success", "data": { "id": 1, ... } }
        // Maka: return User.fromJson(responseData['data']);
        
        // Jika JSON-nya langsung user: { "id": 1, ... }
        // Maka: return User.fromJson(responseData);
        
        // Asumsi struktur mirip LoginModel:
        return User.fromJson(responseData['data']); 
      } else {
        log("Gagal mengambil profil: ${response.body}");
        return null;
      }
    } catch (e) {
      log("Error getUserProfile: $e");
      return null;
    }
  }