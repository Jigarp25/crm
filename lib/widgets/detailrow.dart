import 'package:flutter/material.dart';
import 'package:crm/utils/ui_utils.dart';

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? trailingIcon;
  final VoidCallback? onTap;
  final Color? iconBgColor;
  final Color? trailingIconColor;

   const DetailRow({super.key, required this.label, required this.value,this.trailingIcon,this.trailingIconColor,this.onTap,this.iconBgColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top:4),
          alignment: Alignment.bottomCenter,
          child:Icon(
            _getIcon(label),
            color: Colors.deepPurple,
            size: 28,
          ),
        ),
        hSpace(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              vSpace(4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        if (trailingIcon != null)
          Container(
            margin: const EdgeInsets.only(left: 8, top: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconBgColor ?? const Color(0xff5b3dde),
            ),
            child: IconButton(
              onPressed: onTap,
              icon: Icon(trailingIcon,color: trailingIconColor?? Color(0xffffffff),size: 20,),
            ),
          )
      ],
    );
  }

  IconData _getIcon(label) {
    final cleanedLabel =label.toLowerCase().replaceAll(':','').trim();
    switch (cleanedLabel) {
      case 'description':
        return Icons.description_outlined;
      case 'status':
        return Icons.flag_outlined;
      case 'amount':
        return Icons.currency_rupee_outlined;
      case 'email':
        return Icons.email_outlined;
      case 'phone':
        return Icons.phone_outlined;
      case 'address':
        return Icons.location_on_outlined;
      case 'company name':
        return Icons.apartment_outlined;
      case 'customer':
        return Icons.people_alt_outlined;
      case 'number of deals assigned':
        return Icons.assignment_ind_outlined;
      case 'number of leads assigned':
        return Icons.assignment_ind_outlined;
      case 'deal title':
        return Icons.local_offer_outlined;
      case 'assigned to':
        return Icons.person_outlined;
      default:
        return Icons.info_outline;
    }
  }
}


