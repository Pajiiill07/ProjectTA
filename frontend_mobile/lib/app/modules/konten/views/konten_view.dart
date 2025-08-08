import 'package:flutter/material.dart';
import 'package:frontend_mobile/app/routes/app_pages.dart';
import 'package:frontend_mobile/utils/constant_asset.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/konten_controller.dart';

class KontenView extends GetView<KontenController> {
  const KontenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Educational Content"),
        backgroundColor: Colors.transparent,
      ),
      body: Obx(() {
        final konten = Get.arguments;
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromRGBO(216, 224, 167, 1.0),
            ),
          );
        }

        if (controller.KontenList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.article_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  "Belum ada konten tersedia",
                  style: GoogleFonts.epilogue(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        // Get latest content (first item) and other contents
        final latestContent = controller.KontenList.last;
        final otherContents = controller.KontenList.length > 1
            ? controller.KontenList.sublist(0, controller.KontenList.length - 1) // ambil dari index 0 sampai sebelum terakhir
            : <dynamic>[];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Latest Content Section
              Text(
                "Latest Content",
                style: GoogleFonts.epilogue(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              /// Latest Content Card
              _buildLatestContentCard(latestContent),

              /// Divider
              if (otherContents.isNotEmpty) ...[
                const Divider(
                  height: 32,
                  color: Color.fromRGBO(216, 224, 167, 1.0),
                ),

                /// More Content Section
                Text(
                  "More Content",
                  style: GoogleFonts.epilogue(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                /// Other Contents List
                ListView.builder(
                  itemCount: otherContents.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final content = otherContents[index];
                    return _buildContentListItem(content, index);
                  },
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildLatestContentCard(dynamic content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Content Image
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: content.kategori != null
                ? Image.asset(
              _getImageByCategory(content.kategori),
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: Colors.grey,
                  ),
                );
              },
            )
                : Container(
              color: Colors.grey[200],
              child: const Icon(
                Icons.article,
                size: 50,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        /// Content Title
        Text(
          content.judul ?? "No Title",
          style: GoogleFonts.epilogue(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),

        /// Content Source
        Text(
          "Sumber : ${content.sumber ?? 'Unknown'}",
          style: GoogleFonts.epilogue(
            fontSize: 13,
            color: const Color.fromRGBO(152, 152, 152, 1.0),
          ),
        ),
        const SizedBox(height: 8),

        /// Read More Button
        ElevatedButton(
          onPressed: () {
            Get.toNamed(Routes.DETAIL_KONTEN, arguments: content);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(253, 255, 241, 1.0),
            side: const BorderSide(
              color: Color.fromRGBO(216, 224, 167, 1.0),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            "Read More",
            style: GoogleFonts.epilogue(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentListItem(dynamic content, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Get.toNamed(Routes.DETAIL_KONTEN, arguments: content);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Content Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: content.kategori != null
                      ? Image.asset(
                    _getImageByCategory(content.kategori),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 30,
                          color: Colors.grey,
                        ),
                      );
                    },
                  )
                      : Container(
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.article,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              /// Content Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content.judul ?? "No Title",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.epilogue(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Sumber : ${content.sumber ?? 'Unknown'}",
                      style: GoogleFonts.epilogue(
                        fontSize: 13,
                        color: const Color.fromRGBO(152, 152, 152, 1.0),
                      ),
                    ),
                    if (content.kategori != null) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(216, 224, 167, 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          content.kategori,
                          style: GoogleFonts.epilogue(
                            fontSize: 11,
                            color: const Color.fromRGBO(45, 43, 40, 1.0),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper method to get image based on category
  String _getImageByCategory(String? category) {
    if (category == null) return ConstantAssets.imgKonten2;

    switch (category.toLowerCase()) {
      case 'artikel':
        return ConstantAssets.imgKonten3;
      case 'tips':
        return ConstantAssets.imgKonten2;
      default:
        return ConstantAssets.imgKonten1;
    }
  }
}