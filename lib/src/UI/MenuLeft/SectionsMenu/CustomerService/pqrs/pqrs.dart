import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wawamko/src/Models/Pqrs/response_pqrs.dart';
import 'package:wawamko/src/Providers/pqrs_provider.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/CustomerService/pqrs/createPqrs.dart';
import 'package:wawamko/src/UI/MenuLeft/SectionsMenu/CustomerService/pqrs/detailPqrs.dart';
import 'package:wawamko/src/Utils/Strings.dart';
import 'package:wawamko/src/Utils/colors.dart';
import 'package:wawamko/src/Utils/utils.dart';
import 'package:wawamko/src/Widgets/DialogLoading.dart';
import 'package:wawamko/src/Widgets/widgets.dart';


class PqrsPage extends StatefulWidget {
  const PqrsPage({Key? key}) : super(key: key);

  @override
  _PqrsPageState createState() => _PqrsPageState();
}

class _PqrsPageState extends State<PqrsPage> with TickerProviderStateMixin {

  final RefreshController _refreshControllerOpen = RefreshController();
  final RefreshController _refreshControllerClosed = RefreshController();
  late AnimationController _animationController;
  late AnimationController _animation2Controller;
  late PQRSProvider pqrsProvider;
  late TabController _tabController;
  var isTabOnTap = true;
  int offset = 0;

  @override
  void initState() {
    _animationController =  AnimationController(vsync: this,duration: Duration(seconds: 1));
    _animation2Controller =  AnimationController(vsync: this,duration: Duration(seconds: 1));
    _tabController = TabController(vsync: this, length: 2,initialIndex: 0);


    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      getPqrs("open");
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animation2Controller.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pqrsProvider = Provider.of<PQRSProvider>(context);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _animationController.reset();
      _animationController.forward();
    });
    return Scaffold(
      body: SafeArea(child: _body(context)),
    );
  }

  _changeTab(int index){
    print("index$index");
    this.offset = 0;
    if(index == 0){
      getPqrs("open");
    }else{
      getPqrs("close");
    }
  }
  
  Widget _body(BuildContext context){
    return Column(
      children: [
        simpleHeader(context, _childHeader(context)),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                Strings.pqrs,
                style: TextStyle(
                  fontFamily: Strings.fontBold,
                  fontSize: 18,
                  color: CustomColors.red
                ),
              ),
              Expanded(
                child: Container(),
              ),
              GestureDetector(
                onTap: _createPQRS,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 32,vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: CustomColors.blue
                  ),
                  child: Text(
                    Strings.fontBold,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: Strings.fontBold
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 20),
        TabBar(
          controller: _tabController,
          indicatorColor: CustomColors.redTour,
          unselectedLabelColor: CustomColors.blackLetter.withOpacity(.56),
          labelColor: CustomColors.yellow,
          onTap: (index){
            _changeTab(index);
          },
          tabs: [
            Tab(

              child: FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(curve: Curves.ease,parent: _animationController)),
                  child: Text(Strings.opened)
              ),
            ),
            Tab(
              child: FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(curve: Curves.ease,parent: _animationController)),
                  child: Text(Strings.closed)
              ),
            ),
          ],),
        Visibility(
          visible: pqrsProvider.isLoadingPqrs,
            child: Expanded(child: DialogLoadingAnimated())),
        Visibility(
          visible: !pqrsProvider.isLoadingPqrs,
            child: Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              _listPqrs(true),
              _listPqrs(false),
            ],
          ),
        )),

      ],
    );
  }

  _listPqrs(bool isOpen) {
    return SmartRefresher(
      controller: isOpen ? _refreshControllerOpen : _refreshControllerClosed,
      enablePullUp: true,
      enablePullDown: true,
      onRefresh: _pullToRefresh,
      onLoading: _onLoading,
      child: pqrsProvider.listPqrs.isEmpty ? Center(
        child: emptyPage(
        description: Strings.thisIsSoEmptyDescription,
        title: Strings.thisIsSoEmpty,
        image: "ic_empty_order.png"
    )) : ListView.builder(
        padding: EdgeInsets.only(top: 10),
          itemCount: pqrsProvider.listPqrs.length,
          shrinkWrap: true,
          itemBuilder: (context,index){
            return itemPqrs(pqrsProvider.listPqrs[index], context,_goToDetailPqrs);
          })
    );
  }


  _goToDetailPqrs(ItemPqrs itemPqrs){
    Navigator.of(context).push(
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: DetailPqrs(itemPqrs: itemPqrs),
        duration: Duration(milliseconds: 700),
      ),
    );
  }



  _createPQRS(){
    Navigator.of(context).push(
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: CreatePqrs(),
        duration: Duration(milliseconds: 700),
      ),
    ).then((value) {
      if(value == "update"){
        getPqrs("open");
      }
    });
  }


  Widget _childHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            Strings.contactUs,
            style: TextStyle(
              fontSize: 16,
              fontFamily: Strings.fontRegular,
              color: CustomColors.white,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          child: InkWell(
            child: Container(
              width: 45,
              height: 45,
              child: Image(
                image: AssetImage("Assets/images/ic_arrow.png"),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }

  _pullToRefresh(){
    offset = 0;
    if(_tabController.index == 0){
      getPqrs("open");
      _refreshControllerOpen.refreshCompleted();
    }else{
      getPqrs("close");
      _refreshControllerClosed.refreshCompleted();
    }


  }

  _onLoading() async {
    if(offset < pqrsProvider.totalPages){
      offset++;
      if(_tabController.index == 0){
        getPqrs("open");
      }else{
        getPqrs("close");
      }
    }
    if(_tabController.index == 0){
      _refreshControllerOpen.loadComplete();
    }else{
      _refreshControllerClosed.loadComplete();
    }

  }

  getPqrs(String status) {
    print("status $status");
    utils.check().then((value) async {
      if (value) {
        Future<dynamic> pqrsFuture =
        pqrsProvider.getPqrs(status, offset);
        await pqrsFuture.then((value) {});
      } else {
        pqrsProvider.listPqrs = [];
        utils.showSnackBarError(context, Strings.internetError);
      }
    });
  }

}



