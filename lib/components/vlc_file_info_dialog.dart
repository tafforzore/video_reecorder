import 'package:flutter/material.dart';

import 'action_button.dart';

class VlcFileInfoDialog extends StatefulWidget {
  final String fileName;
  final String filePath;
  final String fileType;
  final String duration;
  final String resolution;
  final String fileSize;
  final String videoCodec;
  final String audioCodec;
  final String frameRate;
  final String bitrate;
  final String? createdDate;
  final String? modifiedDate;
  final String? lastAccessedDate;

  const VlcFileInfoDialog({
    super.key,
    required this.fileName,
    required this.filePath,
    required this.fileType,
    required this.duration,
    required this.resolution,
    required this.fileSize,
    this.videoCodec = 'H.264',
    this.audioCodec = 'AAC',
    this.frameRate = '30 fps',
    this.bitrate = '2 Mbps',
    this.createdDate,
    this.modifiedDate,
    this.lastAccessedDate,
  });

  @override
  State<VlcFileInfoDialog> createState() => _VlcFileInfoDialogState();
}

class _VlcFileInfoDialogState extends State<VlcFileInfoDialog> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: 700,
        height: 650,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF0A0A1A),
              const Color(0xFF151530),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.cyanAccent.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withOpacity(0.1),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            // Header avec titre
            _buildHeader(),

            // Onglets
            _buildTabs(),

            // Contenu des onglets
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildGeneralTab(),
                  _buildTechnicalTab(),
                  _buildMediaTab(),
                  _buildSecurityTab(),
                  _buildAdvancedTab(),
                ],
              ),
            ),

            // Boutons d'action
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.cyanAccent.withOpacity(0.1),
            Colors.blueAccent.withOpacity(0.1),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: Colors.cyanAccent.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            // Icône du type de fichier
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: widget.fileType == 'video'
                    ? LinearGradient(
                  colors: [
                    Colors.cyanAccent,
                    Colors.blueAccent,
                  ],
                )
                    : LinearGradient(
                  colors: [
                    Colors.purpleAccent,
                    Colors.pinkAccent,
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: widget.fileType == 'video'
                        ? Colors.cyanAccent.withOpacity(0.3)
                        : Colors.purpleAccent.withOpacity(0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Icon(
                widget.fileType == 'video' ? Icons.videocam : Icons.music_note,
                color: Colors.black,
                size: 20,
              ),
            ),

            const SizedBox(width: 16),

            // Titre
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Propriétés de : ${widget.fileName}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.filePath,
                    style: TextStyle(
                      color: Colors.blueGrey.shade400,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Bouton fermer
            CyberCircleButton(
              icon: Icons.close,
              onPressed: () => Navigator.pop(context),
              color: Colors.redAccent,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.cyanAccent.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.cyanAccent,
        unselectedLabelColor: Colors.blueGrey.shade400,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.cyanAccent,
              width: 2,
            ),
          ),
        ),
        labelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        tabs: const [
          Tab(text: 'Général'),
          Tab(text: 'Technique'),
          Tab(text: 'Média'),
          Tab(text: 'Sécurité'),
          Tab(text: 'Avancé'),
        ],
      ),
    );
  }

  Widget _buildGeneralTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Informations générales
          _buildSectionTitle('Informations générales'),

          _buildPropertyRow(
            label: 'Type du fichier :',
            value: widget.fileType == 'video'
                ? 'Fichier Vidéo (.mp4, .avi, .mkv)'
                : 'Fichier Audio (.mp3, .wav, .flac)',
          ),

          _buildPropertyRow(
            label: 'S\'ouvre avec :',
            value: 'Lecteur Multimédia VLC',
            withEditButton: true,
          ),

          _buildPropertyRow(
            label: 'Emplacement :',
            value: widget.filePath,
          ),

          _buildPropertyRow(
            label: 'Taille :',
            value: widget.fileSize,
          ),

          _buildPropertyRow(
            label: 'Sur disque :',
            value: widget.fileSize,
          ),

          const SizedBox(height: 30),

          // Dates
          _buildSectionTitle('Dates'),

          _buildPropertyRow(
            label: 'Créé le :',
            value: widget.createdDate ?? 'Non disponible',
          ),

          _buildPropertyRow(
            label: 'Modifié le :',
            value: widget.modifiedDate ?? 'Non disponible',
          ),

          _buildPropertyRow(
            label: 'Dernier accès le :',
            value: widget.lastAccessedDate ?? 'Non disponible',
          ),

          const SizedBox(height: 30),

          // Attributs
          _buildSectionTitle('Attributs'),

          _buildAttributeCheckbox('Lecture seule', false),
          _buildAttributeCheckbox('Archive', true),
          _buildAttributeCheckbox('Système', false),
          _buildAttributeCheckbox('Caché', false),

          _buildActionButton(
            label: 'Avancé...',
            onPressed: () {
              _tabController.animateTo(4);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicalTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Informations techniques'),

          _buildPropertyRow(
            label: 'Codec vidéo :',
            value: widget.videoCodec,
            withDetail: true,
          ),

          _buildPropertyRow(
            label: 'Codec audio :',
            value: widget.audioCodec,
            withDetail: true,
          ),

          _buildPropertyRow(
            label: 'Débit binaire :',
            value: widget.bitrate,
          ),

          _buildPropertyRow(
            label: 'Taux d\'échantillonnage :',
            value: '48 kHz',
          ),

          _buildPropertyRow(
            label: 'Canaux audio :',
            value: 'Stereo (2.0)',
          ),

          _buildPropertyRow(
            label: 'Profondeur de bits :',
            value: '16 bits',
          ),

          const SizedBox(height: 30),

          _buildSectionTitle('Conteneur'),

          _buildPropertyRow(
            label: 'Format :',
            value: widget.fileName.split('.').last.toUpperCase(),
          ),

          _buildPropertyRow(
            label: 'Version :',
            value: 'MP4 v2',
          ),

          _buildPropertyRow(
            label: 'Durée totale :',
            value: widget.duration,
          ),
        ],
      ),
    );
  }

  Widget _buildMediaTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Informations multimédias'),

          if (widget.fileType == 'video') ...[
            _buildMediaInfoCard(
              icon: Icons.videocam,
              title: 'Vidéo',
              items: {
                'Résolution': widget.resolution,
                'Fréquence d\'images': widget.frameRate,
                'Format': widget.videoCodec,
                'Débit vidéo': widget.bitrate,
                'Ratio d\'aspect': '16:9',
                'Espace colorimétrique': 'BT.709',
              },
              color: Colors.cyanAccent,
            ),

            const SizedBox(height: 20),
          ],

          _buildMediaInfoCard(
            icon: Icons.volume_up,
            title: 'Audio',
            items: {
              'Codec': widget.audioCodec,
              'Canaux': 'Stereo (2.0)',
              'Fréquence': '48 kHz',
              'Débit audio': '192 kbps',
              'Profondeur': '16 bits',
              'Langue': 'Français',
            },
            color: Colors.purpleAccent,
          ),

          const SizedBox(height: 20),

          _buildMediaInfoCard(
            icon: Icons.subtitles,
            title: 'Sous-titres',
            items: {
              'Disponibles': '3 pistes',
              'Formats': 'SRT, VTT',
              'Langues': 'Français, Anglais, Espagnol',
              'Encodage': 'UTF-8',
            },
            color: Colors.greenAccent,
          ),

          const SizedBox(height: 20),

          _buildMediaInfoCard(
            icon: Icons.info,
            title: 'Métadonnées',
            items: {
              'Artiste': 'Inconnu',
              'Album': 'Inconnu',
              'Année': '2024',
              'Genre': 'Non spécifié',
              'Éditeur': 'VLC Media Player',
            },
            color: Colors.orangeAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Sécurité et permissions'),

          _buildSecurityInfoCard(
            title: 'Permissions système',
            status: 'Autorisé',
            statusColor: Colors.greenAccent,
            items: {
              'Lecture': 'Autorisée',
              'Écriture': 'Autorisée',
              'Exécution': 'Non autorisée',
              'Suppression': 'Autorisée',
            },
          ),

          const SizedBox(height: 20),

          _buildSecurityInfoCard(
            title: 'Signature numérique',
            status: 'Non signé',
            statusColor: Colors.orangeAccent,
            items: {
              'Certificat': 'Aucun',
              'Émetteur': 'Non applicable',
              'Date de signature': 'Non applicable',
              'Validité': 'Non vérifiée',
            },
          ),

          const SizedBox(height: 20),

          _buildSecurityInfoCard(
            title: 'Intégrité du fichier',
            status: 'Vérifié',
            statusColor: Colors.greenAccent,
            items: {
              'Hash MD5': 'a1b2c3d4e5f6...',
              'Hash SHA-256': 'f6e5d4c3b2a1...',
              'Vérification': 'Complète',
              'Dernière analyse': 'Aujourd\'hui',
            },
          ),

          const SizedBox(height: 20),

          _buildActionButton(
            label: 'Vérifier les mises à jour de sécurité',
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Paramètres avancés'),

          _buildAdvancedSetting(
            title: 'Optimisation du cache',
            description: 'Améliore les performances de lecture',
            value: 75,
            unit: '%',
            color: Colors.cyanAccent,
          ),

          const SizedBox(height: 20),

          _buildAdvancedSetting(
            title: 'Buffer réseau',
            description: 'Tampon pour les flux réseau',
            value: 1500,
            unit: 'ms',
            color: Colors.purpleAccent,
          ),

          const SizedBox(height: 20),

          _buildAdvancedSetting(
            title: 'Qualité de ré-échantillonnage',
            description: 'Qualité de conversion audio',
            value: 4,
            unit: '/10',
            color: Colors.orangeAccent,
          ),

          const SizedBox(height: 20),

          _buildSectionTitle('Informations de débogage'),

          _buildDebugInfo(
            'Chemin complet',
            widget.filePath,
            Colors.blueGrey.shade400,
          ),

          _buildDebugInfo(
            'UID système',
            '0x${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}',
            Colors.blueGrey.shade400,
          ),

          _buildDebugInfo(
            'Index de fichier',
            '${widget.fileName.hashCode.abs()}',
            Colors.blueGrey.shade400,
          ),

          const SizedBox(height: 20),

          _buildActionButton(
            label: 'Exporter le rapport technique',
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.cyanAccent,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildPropertyRow({
    required String label,
    required String value,
    bool withEditButton = false,
    bool withDetail = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.blueGrey.shade300,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
          if (withEditButton)
            Container(
              width: 100,
              height: 28,
              margin: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.cyanAccent.withOpacity(0.3),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Modifier...',
                    style: TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          if (withDetail)
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: Colors.cyanAccent,
            ),
        ],
      ),
    );
  }

  Widget _buildAttributeCheckbox(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.cyanAccent.withOpacity(0.5),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: value
                ? Icon(
              Icons.check,
              size: 14,
              color: Colors.cyanAccent,
            )
                : null,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: Colors.blueGrey.shade300,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaInfoCard({
    required IconData icon,
    required String title,
    required Map<String, String> items,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.05),
            Colors.transparent,
          ],
        ),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...items.entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      '${entry.key} :',
                      style: TextStyle(
                        color: Colors.blueGrey.shade400,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityInfoCard({
    required String title,
    required String status,
    required Color statusColor,
    required Map<String, String> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blueGrey.shade800,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    border: Border.all(
                      color: statusColor.withOpacity(0.3),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...items.entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        color: Colors.blueGrey.shade400,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedSetting({
    required String title,
    required String description,
    required double value,
    required String unit,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blueGrey.shade800,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                color: Colors.blueGrey.shade400,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: value,
                    min: 0,
                    max: unit == '%' ? 100 : (unit == 'ms' ? 5000 : 10),
                    onChanged: (newValue) {},
                    activeColor: color,
                    inactiveColor: Colors.blueGrey.shade800,
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade900,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${value.toInt()}$unit',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDebugInfo(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label :',
              style: TextStyle(
                color: Colors.blueGrey.shade400,
                fontSize: 11,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontFamily: 'Monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.cyanAccent.withOpacity(0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward,
                size: 14,
                color: Colors.cyanAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.cyanAccent.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildDialogButton(
            text: 'Annuler',
            color: Colors.redAccent,
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 12),
          _buildDialogButton(
            text: 'Appliquer',
            color: Colors.cyanAccent,
            onPressed: () {},
          ),
          const SizedBox(width: 12),
          _buildDialogButton(
            text: 'OK',
            color: Colors.greenAccent,
            isPrimary: true,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return ActionButtons(
      onPressed: onPressed,
      text: text,
      backgroundColor: isPrimary
          ? color.withOpacity(0.2)
          : Colors.transparent,
      textColor: color,
      borderColor: color.withOpacity(0.5),
      gradientColors: isPrimary
          ? [
        color.withOpacity(0.8),
        color.withOpacity(0.4),
      ]
          : null,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      withGlowEffect: isPrimary,
    );
  }
}

// Bouton circulaire cyberpunk (version simplifiée)
class CyberCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final double size;

  const CyberCircleButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color = Colors.cyanAccent,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.8),
                color.withOpacity(0.4),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.black,
            size: size * 0.5,
          ),
        ),
      ),
    );
  }
}