import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:invoice_gen/createInvoice/database/dao/FormDAO.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:nanoid/nanoid.dart';
class InvoiceDetailWidget extends StatefulWidget {
  final InvoiceDetails invoiceDetails;
  final int pageIndex;
  final Function validateController;
  InvoiceDetailWidget(this.invoiceDetails,this.pageIndex,this.validateController);

  @override
  _InvoiceDetailWidgetState createState() => _InvoiceDetailWidgetState();
}

class _InvoiceDetailWidgetState extends State<InvoiceDetailWidget> {
  final formKey = new GlobalKey<FormState>();
  //date range
  static DateTime? minYear;
  static DateTime? maxYear;
  var custom_length_id = nanoid(3);
  String getDateString(DateTime date) =>
      "${date.day}/${date.month}/${date.year}";

  DateTime getYear(int value) {
    return new DateTime(DateTime.now().year + value);
  }

  @override
  void initState() {
    super.initState();
    //init fields
    minYear = getYear(-2);
    maxYear = getYear(2);
  }

  void validateForm() {
    if (formKey.currentState!.validate()) {
      widget.validateController(widget.pageIndex,false);
      formKey.currentState!.save();
    }
    else {
      //prevent procced to next page if validation is not successful
      widget.validateController(widget.pageIndex,true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      onChanged: validateForm,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Invoice Details",
                textAlign: TextAlign.left,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),
          Column(
            children: [
              TextFormField(
                controller: widget.invoiceDetails.invoiceNoTxtCtrl,
                maxLength: 10,
                textDirection: TextDirection.ltr,
                decoration: InputDecoration(labelText: "PDF Name",

                ),
                validator: (String? value) {
                  return value!.isEmpty ? 'PDF Name is Required' : null;
                },
                onSaved: (String? value) {
                  widget.invoiceDetails.invoiceNumber = value!;
                  widget.invoiceDetails.invoiceNoTxtCtrl.text = widget.invoiceDetails.invoiceNumber!;
                },
                  onChanged: (text) {
                    // TextSelection previousSelection = billingDetails.companyNameTxtCtrl.selection;
                    // billingDetails.companyNameTxtCtrl.text = text;
                    // billingDetails.companyNameTxtCtrl.selection = previousSelection;
                    final val = TextSelection.collapsed(offset:widget.invoiceDetails.invoiceNoTxtCtrl.text.length);
                    widget.invoiceDetails.invoiceNoTxtCtrl.selection = val;
                  }
              ),
              _buildDateOfIssue(),
              _subHeaderTitle("Date Of Service"),
              _buildDateOfService(),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateOfIssue() {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            controller: widget.invoiceDetails.dateOfIssue!.dateOfIssueCtrl,
            maxLength: 10,
            decoration: InputDecoration(labelText: 'Date Of Issue',counter: Offstage(),),
            validator: (String? value) {
              return value!.isEmpty ? 'Date of Issue is Required' : null;
            },
            onSaved: (String? value) {
              widget.invoiceDetails.dateOfIssue = new DateOfIssue(doi: value);
            },
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2, top: 20, right: 2),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade500,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            height: 30,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: () {
                DatePicker.showDatePicker(
                  context,
                  showTitleActions: true,
                  minTime: minYear,
                  maxTime: maxYear,
                  onChanged: (date) {},
                  onConfirm: (date) {
                    setState(() {
                      widget.invoiceDetails.dateOfIssue!.doi =
                          getDateString(date);
                      widget.invoiceDetails.dateOfIssue = new DateOfIssue(
                          doi: widget.invoiceDetails.dateOfIssue!.doi);
                    });
                    new Future.delayed(new Duration(seconds: 1), () {
                      validateForm();
                    });
                  },
                  currentTime: DateTime.now(),
                  locale: LocaleType.en,
                  theme: DatePickerTheme(
                    doneStyle: TextStyle(color: Colors.white),
                    itemStyle: TextStyle(color: Colors.white70),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                );
              },
              child: Text(
                "Select Date",
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _subHeaderTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildDateOfService() {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            controller: widget.invoiceDetails.dateOfService!.firstDateTxtCtrl,
            maxLength: 10,
            decoration: InputDecoration(labelText: 'From',counter: Offstage(),),
            // validator: (String? value) {
            //   return value!.isEmpty ? 'Empty' : null;
            // },
            onSaved: (String? value) {
              widget.invoiceDetails.dateOfService!.firstDate = value!;
            },
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextFormField(
            controller: widget.invoiceDetails.dateOfService!.lastDateTxtCtrl,
            maxLength: 10,
            decoration: InputDecoration(labelText: 'To',counter: Offstage(),),
            // validator: (String? value) {
            //   return value!.isEmpty ? 'Empty' : null;
            // },
            onSaved: (String? value) {
              widget.invoiceDetails.dateOfService!.lastDate = value;
            },
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2, top: 20, right: 2),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade500,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            height: 30,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: () async {
                final List<DateTime> picked = await DateRangePicker.showDatePicker(
                  context: context,
                  initialFirstDate: DateTime.now(),
                  initialLastDate:
                      (new DateTime.now()).add(new Duration(days: 7)),
                  firstDate: minYear,
                  lastDate: maxYear,
                );
                if (picked != null && picked.length == 2) {
                  String firstDate = getDateString(picked[0]);
                  String lastDate = getDateString(picked[1]);
                  setState(() {
                    widget.invoiceDetails.dateOfService = new DateOfService(
                        firstDate: firstDate, lastDate: lastDate);
                  });
                } else if (picked != null && picked.length == 1) {
                  String firstDate = getDateString(picked[0]);
                  setState(() {
                    widget.invoiceDetails.dateOfService =
                        new DateOfService(firstDate: firstDate, lastDate: null);
                  });
                }

                new Future.delayed(new Duration(seconds: 1), () {
                  validateForm();
                });
              },
              child: Text(
                "Select Date",
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
