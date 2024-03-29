import 'package:flutter/material.dart';
import 'package:invoice_gen/createInvoice/database/dao/pdfDAO.dart';

class ConfirmDeleteAlertBoxButton extends StatelessWidget {
  final Function deleteFunction;
  final PdfDB pdf;

  ConfirmDeleteAlertBoxButton(this.deleteFunction, this.pdf);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.delete,
        color: Colors.red[600],
      ),
      onPressed: () async {
        showAlertDialog(
            context: context, deleteFunction: deleteFunction, pdf: pdf);
      },
    );
  }

  showAlertDialog({required BuildContext context, required Function deleteFunction, required PdfDB pdf}) {
    var result;
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
        deleteFunction(false, pdf);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {
        Navigator.of(context).pop();
        deleteFunction(true, pdf);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text(
        "Would you like to delete pfd ${pdf.fileName}?",
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    return result;
  }
}
