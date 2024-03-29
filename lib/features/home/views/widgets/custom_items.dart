import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:khwater/core/constans/colors.dart';
import 'package:khwater/core/functions/custom_snack_bar.dart';
import 'package:khwater/core/styls.dart';
import 'package:khwater/features/home/data/model/custom_messges_model.dart';
import 'package:khwater/features/home/view_model/faviort_cuibt/faviorte_messages_cubit.dart';
import 'package:khwater/features/home/view_model/messages_options_cuibt/messages_options_cubit.dart';
import 'package:khwater/features/home/view_model/messges_cuibt/messegs_cubit.dart';
import 'package:khwater/features/home/view_model/new_messages_cuibt/new_messages_cubit.dart';
import 'package:khwater/features/home/view_model/spical_cuibt/spical_messages_cubit.dart';
import 'package:khwater/features/home/views/widgets/custom_item_icon.dart';
import 'package:khwater/features/search/view_model/search_cubit.dart';
import 'package:share_plus/share_plus.dart';

class CustomItems extends StatelessWidget {
  final int index;
  final CustomMessgesModel messages;
  const CustomItems({super.key, required this.messages, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  messages.message!,
                  style: AppStyls.styleregulard18(context),
                ),
                const SizedBox(height: 8),
                Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: Text(
                      messages.categorie!,
                      style: AppStyls.styleregulard20(context),
                    ))
              ],
            ),
            const Divider(color: kPrimaryColor),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomItemIcon(
                    icon: FontAwesomeIcons.copy,
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: messages.message!));
                      ScaffoldMessenger.of(context).showSnackBar(
                          customSnackBar(context, title: 'copied'.tr()));
                    }),
                CustomItemIcon(
                    icon: Icons.share,
                    onTap: () async {
                      await Share.share(messages.message!);
                    }),
                BlocListener<MessagesOptionsCubit, MessagesOptionsState>(
                  listener: (context, state) {
                    if (state is MessagesOptionsFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          customSnackBar(context, title: state.errorMessage));
                    } else if (state is MessagesOptionsSucsess) {
                      if (index == 0) {
                        BlocProvider.of<MessegsCubit>(context)
                            .getCustomMessages(
                                id: messages.idCategorie!.toInt(),
                                cat: messages.categorie!);
                      } else if (index == 1) {
                        BlocProvider.of<NewMessagesCubit>(context)
                            .getNewMessages();
                      } else if (index == 2) {
                        BlocProvider.of<SpicalMessagesCubit>(context)
                            .getSpical();
                      } else if (index == 3) {
                        BlocProvider.of<FaviorteMessagesCubit>(context)
                            .getFaviorte();
                      } else {
                        BlocProvider.of<SearchCubit>(context).searchMessage();
                      }
                    }
                  },
                  child: CustomItemIcon(
                      icon: messages.isFaviorte == 1
                          ? Icons.favorite
                          : FontAwesomeIcons.heart,
                      onTap: () async {
                        if (messages.isFaviorte == 1) {
                          BlocProvider.of<MessagesOptionsCubit>(context)
                              .deleteFaviort(id: messages.messageId!.toInt());
                        } else {
                          BlocProvider.of<MessagesOptionsCubit>(context)
                              .addFaviort(id: messages.messageId!.toInt());
                        }
                      }),
                ),
              ],
            ),
            // SizedBox(
            //   height: 10,
            // )
          ],
        ),
      ),
    );
  }
}
