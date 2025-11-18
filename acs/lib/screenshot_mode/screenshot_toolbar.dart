import 'package:flutter/material.dart';
import 'screenshot_controller.dart';

/// Панель инструментов для режима создания скриншотов
class ScreenshotToolbar extends StatefulWidget {
  final ScreenshotController controller;
  final VoidCallback onCapture;
  final VoidCallback onToggleToolbar;

  const ScreenshotToolbar({
    super.key,
    required this.controller,
    required this.onCapture,
    required this.onToggleToolbar,
  });

  @override
  State<ScreenshotToolbar> createState() => _ScreenshotToolbarState();
}

class _ScreenshotToolbarState extends State<ScreenshotToolbar> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 10,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        color: Colors.black87,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _isExpanded ? 320 : 60,
          constraints: BoxConstraints(
            maxWidth: _isExpanded ? 320 : 60,
            minWidth: _isExpanded ? 280 : 60,
          ),
          padding: const EdgeInsets.all(8),
          child: _isExpanded ? _buildExpandedToolbar() : _buildCollapsedToolbar(),
        ),
      ),
    );
  }

  Widget _buildCollapsedToolbar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => setState(() => _isExpanded = true),
          tooltip: 'Развернуть панель',
        ),
      ],
    );
  }

  Widget _buildExpandedToolbar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Заголовок и кнопка сворачивания
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Screenshot Mode',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 20),
              onPressed: () => setState(() => _isExpanded = false),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        const Divider(color: Colors.white30),
        const SizedBox(height: 8),

        // Выбор языка
        const Text(
          'Язык:',
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: widget.controller.currentLocale,
            isExpanded: true,
            dropdownColor: Colors.grey[900],
            style: const TextStyle(color: Colors.white),
            underline: const SizedBox(),
            items: ScreenshotController.availableLocales.entries.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.key,
                child: Text('${entry.value} (${entry.key})'),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                widget.controller.setLocale(newValue);
              }
            },
          ),
        ),
        const SizedBox(height: 16),

        // Счётчик скриншотов
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Следующий скриншот:',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                '#${widget.controller.screenshotCounter}',
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Кнопка создания скриншота
        ElevatedButton.icon(
          onPressed: widget.controller.isSaving ? null : widget.onCapture,
          icon: widget.controller.isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.camera_alt),
          label: Text(
            widget.controller.isSaving ? 'Сохранение...' : 'Скриншот (F9)',
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
        const SizedBox(height: 8),

        // Кнопка открытия папки
        OutlinedButton.icon(
          onPressed: widget.controller.openScreenshotsFolder,
          icon: const Icon(Icons.folder_open, size: 16),
          label: const Text('Открыть папку (F11)', style: TextStyle(fontSize: 12)),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.white30),
          ),
        ),
        const SizedBox(height: 8),

        // Кнопка сброса счётчика
        TextButton.icon(
          onPressed: widget.controller.resetCounter,
          icon: const Icon(Icons.refresh, size: 16),
          label: const Text('Сбросить счётчик', style: TextStyle(fontSize: 12)),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),

        // Информация о последнем скриншоте
        if (widget.controller.lastSavedPath != null)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.greenAccent, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Сохранено:',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  widget.controller.lastSavedPath!.split('\\').last,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),

        // Горячие клавиши
        const Divider(color: Colors.white30),
        const Text(
          'Горячие клавиши:',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        _buildHotkey('F9', 'Сделать скриншот'),
        _buildHotkey('F10', 'Скрыть/показать панель'),
        _buildHotkey('F11', 'Открыть папку'),
      ],
    );
  }

  Widget _buildHotkey(String key, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              key,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(color: Colors.white60, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
