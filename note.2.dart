import 'package:dbklik_hris_app/controller/location_controller.dart';
import 'package:dbklik_hris_app/services/hr/jam_service.dart';
import 'package:dbklik_hris_app/utils/styles.dart';
import 'package:dbklik_hris_app/widget/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../router/router_name.dart';
import '../sales_tracking/widget/sales_card_widget.dart';
import '../../model/login_model.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocationController locationController = LocationController();

  late final JamService jamService;

  User? currentUser;

  var newDt = DateFormat('EEEE, dd MMM yyyy', 'id_ID').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    jamService = JamService(
      // roleLevel: '3', // Role 3 bisa akses
    );
  }

  //fungsi load user data dari shared preferences
  void loadUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userJson = prefs.getString('user_data');

      if (userJson != null) {
        setState(() {
          currentUser = User.fromJson(jsonDecode(userJson));
        });
      }
    } catch (e) {
      log("Error loading user data in Home: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _dateAndLocation(),
                _buildCardInfo(),
                Divider(height: 50, thickness: 0.3, color: biru),
                Row(
                  children: [
                    _buildCard(biru, 'total karyawan', '50'),
                    const SizedBox(width: 10.0),
                    _buildCard(abu, 'Peningkatan Anda', '00.00%'),
                  ],
                ),
                Divider(height: 50, thickness: 0.2, color: biru),
                HeaderWidget(title: 'Kehadiran Divisi IT', onPressed: () {}),
                SizedBox(height: 16.sp),
                _buildKehadiran(),
                SizedBox(height: 16.sp),
                HeaderWidget(title: 'All Mission', onPressed: () {}),
                SizedBox(height: 10.sp),
                ...List.generate(
                  2,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SalesMissionCard(
                      onTap: () =>
                          context.goNamed(Routes.detailTaskSalesTracking),
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.description,
                                    color: Colors.blueAccent,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Misi Penjualan",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "2/10 Terselesaikan",
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.hourglass_bottom,
                                    color: Colors.orange,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "01 Mei 2024 - 31 Juli 2024",
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Colors.blueAccent, Colors.lightBlue],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blueAccent.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "20%",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(Color color, String title, String subtitle) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        // width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: style(white, fs: 12.sp)),
            Text(
              subtitle,
              style: style(white, fs: 16.sp, fw: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateAndLocation() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
            decoration: BoxDecoration(
              color: biru.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              newDt,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 11.sp,
              ),
            ),
          ),
          _buildGetCurrentLocation(),
        ],
      ),
    );
  }

  FutureBuilder<Placemark?> _buildGetCurrentLocation() {
    return FutureBuilder<Placemark?>(
      future: locationController.getLocationUser(),
      builder: (context, snapshot) {
        // log('$snapshot');
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return const CircularProgressIndicator();
        } else {
          final placemark = snapshot.data!;

          final subAdministrativeArea = placemark.subAdministrativeArea;

          return Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            runSpacing: 10,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 10,
                ).w,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 7,
                      spreadRadius: 0.5,
                      offset: Offset(0, 2),
                    ),
                  ],
                  color: biru.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(25).w,
                ),
                child: Wrap(
                  spacing: 10,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(Icons.location_city, size: 12.sp, color: Colors.white),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lokasi anda saat ini",
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 8.sp,
                          ),
                        ),
                        Text(
                          subAdministrativeArea ?? 'null',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

Widget _buildKehadiran() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(3, (index) => _buildKehadiranCard())
              .map(
                (card) => Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: card,
                ),
              )
              .toList(),
        ),
      ),
    ),
  );
}

Widget _buildKehadiranCard() {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 5.w),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.blue.shade100, biru],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: const Offset(1, 4),
          blurRadius: 10,
          spreadRadius: -3,
        ),
      ],
    ),
    child: Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: Colors.orange.shade200,
          child: const Icon(Icons.person, color: Colors.white, size: 40),
        ),
        const SizedBox(height: 10),
        Text(
          'Vincent Surja',
          style: TextStyle(
            color: white,
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Head - IT Support',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'HADIR',
            style: TextStyle(
              color: Colors.green.shade800,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildJamKerjaSection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      HeaderWidget(title: 'Jam Kerja', onPressed: () {}),
      SizedBox(height: 10.sp),
    ],
  );
}

Widget _buildCardInfo() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    padding: EdgeInsets.all(16.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 30.r,
              backgroundColor: Colors.blue.shade100,
              child: Icon(Icons.person, size: 30.r, color: Colors.white),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Datang,',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Senjoyo',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 20.h),
        _buildInfoRow('Divisi - Sub Divisi', 'IT - Developer'),
        SizedBox(height: 10.h),
        _buildInfoRow('Jabatan', 'Intern'),
        SizedBox(height: 10.h),
        _buildInfoRow('Cabang', 'Surabaya - ITC'),
      ],
    ),
  );
}

Widget _buildInfoRow(String title, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              color: biru,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    ),
  );
}
