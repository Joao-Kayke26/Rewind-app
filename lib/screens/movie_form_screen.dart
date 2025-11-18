import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../services/api_service.dart';

class MovieFormScreen extends StatefulWidget {
  const MovieFormScreen({super.key});

  @override
  State<MovieFormScreen> createState() => _MovieFormScreenState();
}

class _MovieFormScreenState extends State<MovieFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  bool _isLoading = false;

  final _urlController = TextEditingController();
  final _titleController = TextEditingController();
  final _genreController = TextEditingController();
  final _durationController = TextEditingController();
  final _releaseController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _selectedAge = 'Livre';
  final List<String> _ageOptions = ['Livre', '10', '12', '14', '16', '18'];
  double _rating = 3.0;

  void _saveMovie() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final movieData = {
      "url": _urlController.text,
      "title": _titleController.text,
      "genre": _genreController.text,
      "age": _selectedAge,
      "duration": _durationController.text,
      "points": _rating.toString(),
      "release": _releaseController.text,
      "description": _descriptionController.text,
    };

    final success = await _apiService.createMovie(movieData);

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Filme salvo com sucesso!')),
      );
      Navigator.pop(context, true);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar filme.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    const labelStyle = TextStyle(color: Colors.white70);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Cadastrar Filme'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(controller: _urlController, label: 'Url Imagem'),
              _buildTextField(controller: _titleController, label: 'Título'),
              _buildTextField(controller: _genreController, label: 'Gênero'),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedAge,
                dropdownColor: Colors.grey[900],
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Faixa Etária',
                  labelStyle: labelStyle,
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                ),
                items: _ageOptions.map((age) => DropdownMenuItem(
                  value: age,
                  child: Text(age, style: const TextStyle(color: Colors.white)),
                )).toList(),
                onChanged: (val) => setState(() => _selectedAge = val!),
              ),
              const SizedBox(height: 16),

              _buildTextField(controller: _durationController, label: 'Duração'),
              const SizedBox(height: 20),

              const Text("Nota:", style: TextStyle(fontSize: 16, color: Colors.white)),
              const SizedBox(height: 8),

              RatingBar.builder(
                initialRating: _rating,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemBuilder: (context, _) => const Icon(
                  Icons.star_border,
                  color: Colors.red,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              const SizedBox(height: 16),

              _buildTextField(controller: _releaseController, label: 'Ano', keyboardType: TextInputType.number),

              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  labelStyle: labelStyle,
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                ),
                validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: _isLoading ? null : _saveMovie,
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.save, color: Colors.white),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white54),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
        validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
      ),
    );
  }
}