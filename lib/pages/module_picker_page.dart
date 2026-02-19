
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/module.dart';
import '../models/record.dart';
import 'record_detail_page.dart';
import '../data/record_repo.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ModuleRepository extends ChangeNotifier {

 ModuleRepository([List<Module>? modules])
    : _modules = modules?.toList() ?? [];

   List<Module> _modules;

  static const _cacheDurationKey = 'last_module_refresh';
  static const _etagKey = 'module_etag';
  static const cacheDuration = Duration(days: 3);

  /// Returns a flat copy of all modules.
  ///
  List<Module> get modules => _modules.toList();
  final _modulesUri = Uri.parse('https://ema-thm.github.io/xpd/modules.json');

 //  try to load modules from local cache (SharedPreferences)
  Future<List<Module>?> _loadModulesFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('modules_data');
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      
      return jsonList.map((j) => Module.fromJson(j)).toList();
    }
    return null;
  }

  //try to load modules from asset file
  Future<List<Module>> _loadModulesFromAsset() async {
    try {
      final jsonString = await rootBundle.loadString('assets/modules.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((j) => Module.fromJson(j)).toList();
    } catch (e) {
      // show error in debug console
      debugPrint('Error loading modules from asset: $e');
      return []; 
    }
  }

  Future<void> loadModules() async {
    // 1. try to load from local cache
    _modules = await _loadModulesFromCache() ?? [];
    
    // 2. try to refresh from server
    await refreshModules();
    
    // 3. if no modules loaded yet, load from asset file
    if (_modules.isEmpty) {
      _modules = await _loadModulesFromAsset();
      notifyListeners();
    } else {
      notifyListeners();
    }

  }
  

  Future<void> refreshModules() async {
    final prefs = await SharedPreferences.getInstance();
    final lastRefresh = prefs.getInt(_cacheDurationKey) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;

    // 1. Verification of local Storage (3 days)
    if (now - lastRefresh < cacheDuration.inMilliseconds && _modules.isNotEmpty) {
      debugPrint('Modules chargés depuis le cache local (moins de 3 jours). Saut de la requête HTTP.');
      return;
    }

    // 2. Prepare and send HTTP GET with ETag handling
    final etag = prefs.getString(_etagKey);
    final headers = <String, String>{};
    if (etag != null) {
      // Use of the ETag for conditional GET
      headers['If-None-Match'] = etag; 
    }

    try {
      final response = await http.get(_modulesUri, headers: headers);

      if (response.statusCode == 200) {
        // SUcces : new data available
        final responseBody = utf8.decode(response.bodyBytes);
        final List<dynamic> jsonList = jsonDecode(responseBody);
        _modules = jsonList.map((j) => Module.fromJson(j)).toList();
        
        // Save the new data to SharedPreferences (cache)
        await prefs.setString('modules_data', responseBody);
        await prefs.setInt(_cacheDurationKey, now);

        // Save the new ETag from the response headers
        final newEtag = response.headers['etag'];
        if (newEtag != null) {
          await prefs.setString(_etagKey, newEtag);
        }

        debugPrint('Module are updated from the server sucessfully (HTTP 200).');
        notifyListeners();

      } else if (response.statusCode == 304) {
        //  ('Not Modified')
        // Reset the timer for 3 days
        await prefs.setInt(_cacheDurationKey, now); 
        debugPrint('Module  not modified (HTTP 304).Timer reset.');
      
      } else {
        // failure serveur
        debugPrint('Server error: ${response.statusCode}. Local Cache will be used.');
      }
    } catch (e) {
      // connexion error 
      debugPrint('Impossible to connect with the Sever $e .Local Cache will be used.');
    }

  }
}





class ModulePickerPage extends StatefulWidget { 
  const ModulePickerPage({super.key}) ;
  @override 
  State<ModulePickerPage> createState() => _ModulePickerPageState(); 
} 

class _ModulePickerPageState extends State<ModulePickerPage> { 
  
  final _controller = TextEditingController(); 
  late FocusNode _searchFocusNode;
  
   @override 
void initState() { 
  super.initState(); 
    _controller.addListener(() => setState(() {})); 
    _searchFocusNode = FocusNode(); 
    _searchFocusNode.requestFocus(); 
  }

   @override 
  void dispose() { 
    _controller.dispose(); 
    _searchFocusNode.dispose(); 
  super.dispose(); 
  }

  List<Module> _filterModules(List<Module> modules , List<Record> records) {
    final query = _controller.text.toLowerCase();
    
    final exitingMoluleNumbers = records.map((r) => r.moduleNumber).toSet();
    var availableModules = modules.where((m) => !exitingMoluleNumbers.contains(m.number)).toList();
    availableModules.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    if (query.isEmpty) {
      return availableModules;
    } else {
      return availableModules.where((m) =>
        m.name.toLowerCase().contains(query) ||
        m.number.toLowerCase().contains(query)
      ).toList();
    }
  }

Widget _buildModuleListView(List<Module> filteredModules) {
    if (filteredModules.isEmpty && _controller.text.isNotEmpty) {
      return const Center(child: Text('No module matches your search.'));
    }
    if (filteredModules.isEmpty) {
      return const Center(child: Text('No modules available.'));
    }

    return ListView.separated(
      itemCount: filteredModules.length,
      itemBuilder: (context, index) {
        final module = filteredModules[index];
        return ListTile(
          title: Text('${module.name} (${module.number})'),
          subtitle: Text('${module.crp} Crp'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                // Correction: pass the module converted to a Record
                builder: (context) => RecordDetailPage(record: module.toRecord()), 
              ),
            );
          },
          
        );
      },
      separatorBuilder: (_, _) => const Divider(),
    );
  }  
  
Widget _buildSearchBar() { 
return Padding( 
      padding: const EdgeInsets.all(8), 
      child: SearchBar( 
        hintText: 'Select a module', 
        focusNode: _searchFocusNode, 
        controller: _controller,
        leading: const Icon(Icons.search), 
        trailing: [ 
          IconButton( 
            onPressed: () { 
              _controller.clear(); 
              _searchFocusNode.requestFocus(); 
            }, 
            icon: Icon(Icons.clear), 
          ) 
        ], 
      ), 
    ); 

  }
@override 
  Widget build(BuildContext context) { 
final modules = context.watch<ModuleRepository>().modules; 
final records = context.read<RecordRepository>().records; 
    // Filter modules where a record already exists. 
// Filter modules (name, number) by search query. 
final filteredModules = _filterModules(modules, records); // Todo: Übung
 return Scaffold( 
      body: Column( 
        children: [ 
          _buildSearchBar(), 
          Expanded(child: _buildModuleListView(filteredModules)), 
        ], 
      ),
      floatingActionButton: FloatingActionButton.extended( 
        label: Text('Skip selection'), 
        icon:  Icon(Icons.arrow_forward), 
        onPressed: () => Navigator.pushReplacement( 
          context, 
          MaterialPageRoute(builder: (context) => RecordDetailPage()), 
        ), 
      ),
    );
  }


}