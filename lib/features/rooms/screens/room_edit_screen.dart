import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/models/room_model.dart';
import '../../../../data/providers/room_provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';

class RoomEditScreen extends StatefulWidget {
  final Room room;

  const RoomEditScreen({super.key, required this.room});

  @override
  State<RoomEditScreen> createState() => _RoomEditScreenState();
}

class _RoomEditScreenState extends State<RoomEditScreen> {
  late final TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.room.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roomProvider = Provider.of<RoomProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.editRoom),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final updatedRoom = widget.room.copyWith(
                  name: _nameController.text,
                );

                if (widget.room.id.isEmpty) {
                  await roomProvider.addRoom(updatedRoom);
                } else {
                  await roomProvider.updateRoom(updatedRoom);
                }

                if (mounted) Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: AppStrings.roomName,
                  border: OutlineInputBorder(),
                ),
                validator: Validators.validateName,
              ),
            ],
          ),
        ),
      ),
    );
  }
}