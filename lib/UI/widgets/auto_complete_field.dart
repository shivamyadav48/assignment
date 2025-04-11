import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../service/api.dart';


class OriginDestinationForm extends StatefulWidget {
  const OriginDestinationForm({super.key});

  @override
  OriginDestinationFormState createState() => OriginDestinationFormState();
}

class OriginDestinationFormState extends State<OriginDestinationForm> {
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchField('Origin', _originController),
        SizedBox(height: 16),
        _buildSearchField('Destination', _destinationController),
      ],
    );
  }

  Widget _buildSearchField(String label, TextEditingController controller) {
    return TypeAheadFormField<University>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(Icons.location_on_outlined),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      suggestionsCallback: (pattern) => UniversityApiService.fetchUniversities(pattern),
      itemBuilder: (context, university) {
        return ListTile(
          title: Text(university.name),
          subtitle: Text('${university.country} • ${university.webPage}'),
        );
      },
      onSuggestionSelected: (university) {
        controller.text = university.name;
      },
      noItemsFoundBuilder: (context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("No matches found"),
      ),
    );
  }
}
