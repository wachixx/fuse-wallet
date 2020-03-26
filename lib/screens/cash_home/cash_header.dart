import 'package:flutter/material.dart';
import 'package:localpay/generated/i18n.dart';
import 'package:localpay/models/views/cash_header.dart';
import 'package:localpay/models/app_state.dart';
import 'package:localpay/screens/routes.gr.dart';
import 'package:localpay/screens/send/send_amount_arguments.dart';
import 'package:localpay/utils/format.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:barcode_scan/barcode_scan.dart';

class CashHeader extends StatelessWidget {
  scanBarcode() async {
    try {
      String accountAddress = await BarcodeScanner.scan();
      List<String> parts = accountAddress.split(':');
      if (parts.length == 2 && parts[0] == 'fuse') {
        Router.navigator.pushNamed(Router.sendAmountScreen,
            arguments: SendAmountArguments(
                sendType: SendType.QR_ADDRESS, accountAddress: parts[1]));
      } else {
        print('Account address is not on Fuse');
      }
    } catch (e) {
      print('ERROR - BarcodeScanner');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, CashHeaderViewModel>(
        converter: CashHeaderViewModel.fromStore,
        builder: (_, viewModel) {
          return Container(
            height: 260.0,
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withAlpha(20),
                    blurRadius: 30.0,
                    spreadRadius: 0.0,
                    offset: Offset(
                      0.0,
                      3.0,
                    ),
                  )
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).primaryColorLight,
                    Theme.of(context).primaryColorDark,
                  ],
                ),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Padding(
                        padding:
                            EdgeInsets.only(top: 35, bottom: 35, right: 35),
                        child: Image.asset(
                          'assets/images/menu.png',
                          width: 20,
                        ))),
                Expanded(
                    child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 0.0),
                    child: new RichText(
                      text: new TextSpan(
                        style: Theme.of(context).textTheme.title,
                        children: <TextSpan>[
                          new TextSpan(
                              text: I18n.of(context).hi,
                              style: TextStyle(
                                  fontSize: 33,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.normal)),
                          new TextSpan(
                              text: ' ' + (viewModel?.firstName() ?? ''),
                              style: TextStyle(
                                  fontSize: 33,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                  ),
                )),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 0.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      verticalDirection: VerticalDirection.up,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Container(
                              child: Text(I18n.of(context).balance,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withAlpha(150),
                                      fontSize: 12.0)),
                              padding: EdgeInsets.only(bottom: 6.0),
                            ),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  RichText(
                                    text: new TextSpan(
                                      style: Theme.of(context).textTheme.title,
                                      children: (viewModel
                                                      .community.tokenBalance ==
                                                  null ||
                                              viewModel.community.token == null)
                                          ? <TextSpan>[
                                              new TextSpan(
                                                  text: '0',
                                                  style: new TextStyle(
                                                      fontSize: 30,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ]
                                          : <TextSpan>[
                                              new TextSpan(
                                                  text: formatValue(
                                                      viewModel.community
                                                          .tokenBalance,
                                                      viewModel.community.token
                                                          .decimals),
                                                  style: new TextStyle(
                                                      fontSize: 32,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              new TextSpan(
                                                  text: ' ' +
                                                      viewModel.community.token
                                                          ?.symbol
                                                          .toString(),
                                                  style: new TextStyle(
                                                      fontSize: 18,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      height: 0.0)),
                                            ],
                                    ),
                                  ),
                                ])
                          ],
                        ),
                        new Container(
                          child: Row(children: [
                            new FloatingActionButton(
                                heroTag: 'cash_scanner',
                                backgroundColor: const Color(0xFF292929),
                                elevation: 0,
                                child: Image.asset(
                                  'assets/images/scan.png',
                                  width: 25.0,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                onPressed: scanBarcode)
                          ]),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
