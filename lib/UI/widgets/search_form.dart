import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import '../../service/api.dart';
import 'container_dimensions.dart';

class SearchForm extends StatefulWidget {
  const SearchForm({super.key});

  @override
  SearchFormState createState() => SearchFormState();
}

class SearchFormState extends State<SearchForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController cutoffDateController = TextEditingController();

  String? origin;
  String? destination;
  bool includeNearbyOrigin = false;
  bool includeNearbyDestination = false;
  String? commodity;
  DateTime? cutoffDate;
  bool fcl = true;
  bool lcl = false;
  String? containerSize;
  String? numberOfBoxes;
  String? weight;

  InputDecoration _inputDecoration(String label, {IconData? icon, bool isSuffix = false}) {
    return InputDecoration(
      labelText: label,
      suffixIcon: isSuffix && icon != null ? Icon(icon) : null,
      prefixIcon: !isSuffix && icon != null ? Icon(icon) : null,
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFE8E8E8), width: 1),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFE8E8E8), width: 1),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFE8E8E8), width: 1.5),
      ),
    );
  }


  // Function to handle checkbox toggling while ensuring mutual exclusivity
  void _toggleShipmentType(String type, bool? value) {
    if (value == true) {
      setState(() {
        fcl = (type == 'FCL');
        lcl = (type == 'LCL');
      });
    } else {

      if ((type == 'FCL' && !lcl) || (type == 'LCL' && !fcl)) {
        return;
      }
      setState(() {
        if (type == 'FCL') fcl = false;
        if (type == 'LCL') lcl = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(54),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TypeAheadFormField<University>(
                      textFieldConfiguration: TextFieldConfiguration(
                        decoration: _inputDecoration('Origin', icon: Icons.place_outlined),
                        controller: TextEditingController(text: origin ?? ''),
                        onChanged: (val) => origin = val,
                      ),
                      suggestionsCallback: (pattern) =>
                          UniversityApiService.fetchUniversities(pattern),
                      itemBuilder: (context, university) {
                        return ListTile(
                          title: Text(university.name),
                          subtitle: Text('${university.country} • ${university.webPage}'),
                        );
                      },
                      onSuggestionSelected: (university) {
                        setState(() {
                          origin = university.name;
                        });
                      },
                      noItemsFoundBuilder: (context) =>
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("No matches found"),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TypeAheadFormField<University>(
                      textFieldConfiguration: TextFieldConfiguration(
                        decoration: _inputDecoration('Destination', icon: Icons.place_outlined),
                        controller: TextEditingController(text: destination ?? ''),
                        onChanged: (val) => destination = val,
                      ),
                      suggestionsCallback: (pattern) =>
                          UniversityApiService.fetchUniversities(pattern),
                      itemBuilder: (context, university) {
                        return ListTile(
                          title: Text(university.name),
                          subtitle: Text('${university.country} • ${university.webPage}'),
                        );
                      },
                      onSuggestionSelected: (university) {
                        setState(() {
                          destination = university.name;
                        });
                      },
                      noItemsFoundBuilder: (context) =>
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("No matches found"),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Row(
              children: <Widget>[
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Include nearby origin ports'),
                    value: includeNearbyOrigin,
                    onChanged: (bool? value) {
                      setState(() {
                        includeNearbyOrigin = value!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Include nearby destination ports'),
                    value: includeNearbyDestination,
                    onChanged: (bool? value) {
                      setState(() {
                        includeNearbyDestination = value!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                      decoration: _inputDecoration('Commodity'),
                      value: commodity,
                      onChanged: (String? newValue) {
                        setState(() {
                          commodity = newValue!;
                        });
                      },
                      items: <String>['Electronics', 'Textiles', 'Food', 'Other']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: cutoffDateController,
                      readOnly: true,
                      decoration: _inputDecoration(
                        'Cut Off Date',
                        icon: Icons.calendar_today_outlined,
                        isSuffix: true,
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                          setState(() {
                            cutoffDateController.text = formattedDate;
                            cutoffDate = pickedDate;
                          });
                        }
                      },
                    ),

                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('Shipment Type:'),
                  Row(
                    children: <Widget>[
                      Row(
                        children: [
                          Checkbox(
                            value: fcl,
                            onChanged: (bool? value) => _toggleShipmentType('FCL', value),
                          ),
                          const Text('FCL'),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Row(
                        children: [
                          Checkbox(
                            value: lcl,
                            onChanged: (bool? value) => _toggleShipmentType('LCL', value),
                          ),
                          const Text('LCL'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                // Container Size (wider)
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                      decoration: _inputDecoration('Container Size'),
                      value: containerSize,
                      onChanged: (String? newValue) {
                        setState(() {
                          containerSize = newValue!;
                        });
                      },
                      items: <String>["20'", "40' Standard"]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // No of Boxes
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: _inputDecoration('No of Boxes'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          numberOfBoxes = value;
                        });
                      },
                    ),
                  ),
                ),

                // Weight (Kg)
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: _inputDecoration('Weight (Kg)'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          weight = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.grey,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "To obtain accurate rate for spot rate with guaranteed space and booking, please ensure your container count and weight per container is accurate.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),

            const ContainerDimensions(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: OutlinedButton(
                  onPressed: () {
                    // Add your history button functionality here
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF0139FF)),
                    backgroundColor: const Color(0xFFE6EBFF),
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.search, color: Color(0xFF0139FF), size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Search',
                        style: TextStyle(
                          color: Color(0xFF0139FF),
                          fontWeight: FontWeight.bold,
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
    );
  }
}