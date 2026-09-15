
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FactoryApp());
}

const blue = Color(0xFF253B86);
const red = Color(0xFFD92645);
const green = Color(0xFF70B843);

class FactoryApp extends StatelessWidget {
  const FactoryApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'HORNG CHERNG 工廠管理',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: blue),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      cardTheme: const CardThemeData(elevation: 0, margin: EdgeInsets.zero),
    ),
    home: const LoginPage(),
  );
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: Center(child: SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 460), child: Column(children: [
        ClipRRect(borderRadius: BorderRadius.circular(24), child: Image.asset('assets/horng_cherng_logo.jpeg', height: 180, fit: BoxFit.cover)),
        const SizedBox(height: 20),
        const Text('HORNG CHERNG INDUSTRIAL CO., LTD.', textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: blue)),
        const SizedBox(height: 6),
        const Text('工廠生產管理系統', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 28),
        const TextField(decoration: InputDecoration(labelText: '帳號', prefixIcon: Icon(Icons.person_outline), border: OutlineInputBorder())),
        const SizedBox(height: 12),
        const TextField(obscureText: true, decoration: InputDecoration(labelText: '密碼', prefixIcon: Icon(Icons.lock_outline), border: OutlineInputBorder())),
        const SizedBox(height: 18),
        SizedBox(width: double.infinity, height: 52, child: FilledButton(
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeShell())),
          child: const Text('登入'),
        )),
        const SizedBox(height: 12),
        const Text('V2 MVP・本機示範資料', style: TextStyle(color: Colors.black54)),
      ])),
    ))),
  );
}

class Part {
  String no, name, material, drawing;
  int planned, good, bad, shipped, stock;
  Part(this.no,this.name,this.material,this.planned,this.good,this.bad,this.shipped,this.stock,this.drawing);
  Map<String,dynamic> toJson()=>{'no':no,'name':name,'material':material,'planned':planned,'good':good,'bad':bad,'shipped':shipped,'stock':stock,'drawing':drawing};
  factory Part.fromJson(Map<String,dynamic> j)=>Part(j['no'],j['name'],j['material'],j['planned'],j['good'],j['bad'],j['shipped'],j['stock'],j['drawing']);
}

class Store extends ChangeNotifier {
  List<Part> parts = [
    Part('A-00125','鋁合金支架','SECC 1.0mm',10000,9850,150,8000,2000,'A-00125_V3.pdf'),
    Part('B-00342','電源支架','SUS304 2.0mm',5000,4200,35,3000,1200,'B-00342_V2.pdf'),
  ];
  Future<void> load() async {
    final p=await SharedPreferences.getInstance(); final s=p.getString('parts');
    if(s!=null){parts=(jsonDecode(s) as List).map((e)=>Part.fromJson(e)).toList(); notifyListeners();}
  }
  Future<void> save() async { final p=await SharedPreferences.getInstance(); await p.setString('parts',jsonEncode(parts.map((e)=>e.toJson()).toList())); notifyListeners();}
}
final store=Store();

class HomeShell extends StatefulWidget { const HomeShell({super.key}); @override State<HomeShell> createState()=>_HomeShellState(); }
class _HomeShellState extends State<HomeShell> {
  int index=0;
  final pages=const [DashboardPage(),ProductionPage(),MaterialPage(),QCPage(),DrawingPage()];
  @override void initState(){super.initState();store.load();}
  @override Widget build(BuildContext context)=>Scaffold(
    appBar: AppBar(title: Row(children:[
      ClipRRect(borderRadius:BorderRadius.circular(8),child:Image.asset('assets/horng_cherng_logo.jpeg',width:38,height:38,fit:BoxFit.cover)),
      const SizedBox(width:10), const Expanded(child:Text('HORNG CHERNG',style:TextStyle(fontWeight:FontWeight.w800)))
    ]), actions:[
      IconButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const ScannerPage())),icon:const Icon(Icons.qr_code_scanner)),
      IconButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const ShippingPage())),icon:const Icon(Icons.local_shipping_outlined)),
    ]),
    body:SafeArea(child:pages[index]),
    bottomNavigationBar:NavigationBar(selectedIndex:index,onDestinationSelected:(v)=>setState(()=>index=v),destinations:const[
      NavigationDestination(icon:Icon(Icons.dashboard_outlined),label:'首頁'),
      NavigationDestination(icon:Icon(Icons.precision_manufacturing_outlined),label:'生產'),
      NavigationDestination(icon:Icon(Icons.inventory_2_outlined),label:'貨料'),
      NavigationDestination(icon:Icon(Icons.fact_check_outlined),label:'品管'),
      NavigationDestination(icon:Icon(Icons.description_outlined),label:'圖面'),
    ]),
  );
}

class DashboardPage extends StatelessWidget { const DashboardPage({super.key});
  @override Widget build(BuildContext context)=>AnimatedBuilder(animation:store,builder:(_,__)=>ListView(padding:const EdgeInsets.all(16),children:[
    Container(padding:const EdgeInsets.all(20),decoration:BoxDecoration(
      gradient:const LinearGradient(colors:[blue,Color(0xFF142456)]),borderRadius:BorderRadius.circular(20)),
      child:const Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text('工廠生產管理系統',style:TextStyle(color:Colors.white,fontSize:23,fontWeight:FontWeight.bold)),
        SizedBox(height:6),Text('生產・進出貨・材料・品管・圖面',style:TextStyle(color:Colors.white70))
      ])),
    const SizedBox(height:16),
    GridView.count(crossAxisCount:2,childAspectRatio:1.55,mainAxisSpacing:12,crossAxisSpacing:12,shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),children:[
      metric('生產料號','${store.parts.length}','項',Icons.precision_manufacturing,blue),
      metric('良品','${store.parts.fold<int>(0,(a,b)=>a+b.good)}','pcs',Icons.check_circle,green),
      metric('待出貨','${store.parts.fold<int>(0,(a,b)=>a+b.stock)}','pcs',Icons.local_shipping,Colors.orange),
      metric('不良品','${store.parts.fold<int>(0,(a,b)=>a+b.bad)}','pcs',Icons.warning_amber,red),
    ]),
    const SizedBox(height:18), const Text('料號快速查詢',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold)),
    ...store.parts.map((p)=>Card(child:ListTile(title:Text(p.no),subtitle:Text('${p.name}・${p.material}'),trailing:const Icon(Icons.chevron_right),
      onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>PartDetailPage(part:p)))))),
  ]));
}

Widget metric(String t,String v,String s,IconData i,Color c)=>Card(child:Padding(padding:const EdgeInsets.all(14),child:Row(children:[
  CircleAvatar(backgroundColor:c.withOpacity(.12),child:Icon(i,color:c)),const SizedBox(width:10),
  Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(t,style:const TextStyle(color:Colors.black54)),Text('$v $s',style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold))]))
])));

class ProductionPage extends StatelessWidget {
  const ProductionPage({super.key});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder: (_, __) => Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: store.parts.map((p) => Card(
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PartDetailPage(part: p),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${p.no}  ${p.name}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Chip(
                        label: Text(
                          '${(p.good / p.planned * 100).clamp(0, 100).toStringAsFixed(0)}%',
                        ),
                      ),
                    ],
                  ),
                  Text('計畫 ${p.planned}・良品 ${p.good}・不良 ${p.bad}'),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (p.good / p.planned).clamp(0, 1),
                  ),
                ],
              ),
            ),
          ),
        )).toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAddPart(context),
        icon: const Icon(Icons.add),
        label: const Text('新增工單'),
      ),
    ),
  );
}

Future<void> showAddPart(BuildContext context) async {
  final no=TextEditingController(), name=TextEditingController(), material=TextEditingController(), qty=TextEditingController();
  await showDialog(context:context,builder:(c)=>AlertDialog(title:const Text('新增生產工單'),content:SingleChildScrollView(child:Column(children:[
    TextField(controller:no,decoration:const InputDecoration(labelText:'料號')),TextField(controller:name,decoration:const InputDecoration(labelText:'品名')),
    TextField(controller:material,decoration:const InputDecoration(labelText:'材料')),TextField(controller:qty,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'生產數量')),
  ])),actions:[TextButton(onPressed:()=>Navigator.pop(c),child:const Text('取消')),FilledButton(onPressed:(){
    if(no.text.trim().isEmpty)return; store.parts.add(Part(no.text.trim(),name.text.trim(),material.text.trim(),int.tryParse(qty.text)??0,0,0,0,0,'尚未上傳'));store.save();Navigator.pop(c);
  },child:const Text('建立'))]));
}

class MaterialPage extends StatelessWidget { const MaterialPage({super.key});
 @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(16),children:const[
  StockTile('SECC 冷軋鋼板','1.0 × 1220 × 2440 mm','5,620 kg',green),
  StockTile('白鐵 SUS304','2.0 × 1220 × 2440 mm','3,200 kg',green),
  StockTile('鋁板 5052','1.5 × 1220 × 2440 mm','1,800 kg',Colors.orange),
  StockTile('銅板 C1100','1.0 × 1220 × 2440 mm','620 kg',red),
 ]);
}
class StockTile extends StatelessWidget { final String a,b,c; final Color color; const StockTile(this.a,this.b,this.c,this.color,{super.key});
 @override Widget build(BuildContext context)=>Card(child:ListTile(leading:Icon(Icons.layers,color:color),title:Text(a),subtitle:Text(b),trailing:Text(c,style:const TextStyle(fontWeight:FontWeight.bold))));
}

class QCPage extends StatelessWidget { const QCPage({super.key});
 @override Widget build(BuildContext context)=>AnimatedBuilder(animation:store,builder:(_,__)=>ListView(padding:const EdgeInsets.all(16),children:store.parts.map((p)=>Card(child:ListTile(
  leading:CircleAvatar(backgroundColor:(p.bad==0?green:red).withOpacity(.12),child:Icon(p.bad==0?Icons.check:Icons.priority_high,color:p.bad==0?green:red)),
  title:Text('QC ${p.no}'),subtitle:Text('良品 ${p.good}・不良 ${p.bad}'),trailing:Chip(label:Text(p.bad==0?'合格':'待確認'))
 ))).toList()));
}

class DrawingPage extends StatefulWidget { const DrawingPage({super.key}); @override State<DrawingPage> createState()=>_DrawingPageState(); }
class _DrawingPageState extends State<DrawingPage> {
 String? selected;
 @override Widget build(BuildContext context)=>AnimatedBuilder(animation:store,builder:(_,__)=>ListView(padding:const EdgeInsets.all(16),children:[
  FilledButton.icon(onPressed:()async{final r=await FilePicker.platform.pickFiles(type:FileType.custom,allowedExtensions:['pdf','dwg','dxf','jpg','png']);if(r!=null)setState(()=>selected=r.files.single.name);},icon:const Icon(Icons.upload_file),label:const Text('選擇圖面檔案')),
  if(selected!=null) Padding(padding:const EdgeInsets.all(12),child:Text('已選擇：$selected')),
  ...store.parts.map((p)=>Card(child:ListTile(leading:const Icon(Icons.picture_as_pdf,color:red),title:Text(p.drawing),subtitle:Text('${p.no}・版本管理'),trailing:const Icon(Icons.chevron_right))))
 ]));
}

class ShippingPage extends StatelessWidget { const ShippingPage({super.key});
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('進出貨管理')),body:AnimatedBuilder(animation:store,builder:(_,__)=>ListView(padding:const EdgeInsets.all(16),children:store.parts.map((p)=>Card(child:ListTile(
  leading:const Icon(Icons.local_shipping,color:blue),title:Text(p.no),subtitle:Text('已出貨 ${p.shipped}・庫存 ${p.stock}'),trailing:const Chip(label:Text('出貨紀錄'))
 ))).toList())));
}

class ScannerPage extends StatefulWidget { const ScannerPage({super.key}); @override State<ScannerPage> createState()=>_ScannerPageState(); }
class _ScannerPageState extends State<ScannerPage> {
 bool done=false;
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('QR／條碼掃描')),body:MobileScanner(onDetect:(capture){
   if(done||capture.barcodes.isEmpty)return; final code=capture.barcodes.first.rawValue; if(code==null)return; done=true;
   Part? found; for(final p in store.parts){if(p.no==code){found=p;break;}}
   if(found!=null){Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>PartDetailPage(part:found!)));}
   else{ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('找不到料號：$code')));Future.delayed(const Duration(seconds:2),()=>done=false);}
 }));
}

class PartDetailPage extends StatefulWidget { final Part part; const PartDetailPage({super.key,required this.part}); @override State<PartDetailPage> createState()=>_PartDetailPageState(); }
class _PartDetailPageState extends State<PartDetailPage> {
 @override Widget build(BuildContext context){final p=widget.part;return Scaffold(appBar:AppBar(title:Text(p.no)),body:ListView(padding:const EdgeInsets.all(16),children:[
  Card(child:Padding(padding:const EdgeInsets.all(18),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
   Text(p.name,style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold)),const SizedBox(height:8),Text('材料：${p.material}'),Text('圖面：${p.drawing}')
  ]))),
  const SizedBox(height:12),
  GridView.count(crossAxisCount:2,childAspectRatio:1.7,mainAxisSpacing:10,crossAxisSpacing:10,shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),children:[
   metric('生產',p.planned.toString(),'pcs',Icons.precision_manufacturing,blue),metric('良品',p.good.toString(),'pcs',Icons.check,green),
   metric('不良',p.bad.toString(),'pcs',Icons.close,red),metric('庫存',p.stock.toString(),'pcs',Icons.inventory,Colors.orange),
  ]),
  const SizedBox(height:14),
  FilledButton.icon(onPressed:()=>editCounts(context,p),icon:const Icon(Icons.edit),label:const Text('修改生產／庫存數量')),
 ]));}
}

Future<void> editCounts(BuildContext context, Part p) async {
  final no = TextEditingController(text: p.no);
  final name = TextEditingController(text: p.name);
  final material = TextEditingController(text: p.material);
  final planned = TextEditingController(text: '${p.planned}');
  final good = TextEditingController(text: '${p.good}');
  final bad = TextEditingController(text: '${p.bad}');
  final ship = TextEditingController(text: '${p.shipped}');
  final stock = TextEditingController(text: '${p.stock}');

  await showDialog(
    context: context,
    builder: (c) => AlertDialog(
      title: Text('修改 ${p.no}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: no,
              decoration: const InputDecoration(labelText: '料號'),
            ),
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: '品名'),
            ),
            TextField(
              controller: material,
              decoration: const InputDecoration(labelText: '材料'),
            ),
            TextField(
              controller: planned,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '生產數量'),
            ),
            TextField(
              controller: good,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '良品'),
            ),
            TextField(
              controller: bad,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '不良品'),
            ),
            TextField(
              controller: ship,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '已出貨'),
            ),
            TextField(
              controller: stock,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '庫存'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: c,
              builder: (d) => AlertDialog(
                title: const Text('確認刪除'),
                content: Text('確定要刪除 ${p.no} ${p.name} 嗎？'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(d, false),
                    child: const Text('取消'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(d, true),
                    child: const Text('確定刪除'),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              store.parts.remove(p);
              await store.save();
              if (c.mounted) Navigator.pop(c);
              if (context.mounted) Navigator.pop(context);
            }
          },
          child: const Text(
            '刪除工單',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(c),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () async {
            final newNo = no.text.trim();
            if (newNo.isEmpty) return;

            final index = store.parts.indexOf(p);

            if (index >= 0) {
              store.parts[index] = Part(
                newNo,
                name.text.trim(),
                material.text.trim(),
                int.tryParse(planned.text) ?? p.planned,
                int.tryParse(good.text) ?? p.good,
                int.tryParse(bad.text) ?? p.bad,
                int.tryParse(ship.text) ?? p.shipped,
                int.tryParse(stock.text) ?? p.stock,
                p.drawing,
              );

              await store.save();

              if (c.mounted) Navigator.pop(c);
              if (context.mounted) Navigator.pop(context);
            }
          },
          child: const Text('儲存修改'),
        ),
      ],
    ),
  );
}
