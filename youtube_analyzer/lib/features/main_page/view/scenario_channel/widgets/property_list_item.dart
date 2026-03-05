import 'package:flutter/material.dart';
import 'package:youtube_analyzer/features/main_page/view/scenario_channel/view/property_channel_screen.dart';

class PropertyListItem extends StatelessWidget {
  const PropertyListItem(
      {super.key, required this.propertiesList, required this.index});
  final int index;
  final List propertiesList;

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    final screenWight = MediaQuery.of(context).size.width;

    final bodyStyle = Theme.of(context).textTheme.bodySmall;

    final content = [
      RichText(
        text: TextSpan(style: bodyStyle, children: [
          TextSpan(
            text: 'type: ',
            style: TextStyle(
              color: bodyStyle?.color?.withValues(alpha: 0.7),
            ),
          ),
          TextSpan(
            text: 'string',
            style: TextStyle(
              color: colorTheme.primary,
            ),
          ),
        ]),
      ),
      const SizedBox(width: 16),
      Row(
        children: [
          Opacity(
            opacity: 0.7,
            child: Text(
              'is array: ',
              style: bodyStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          // Icon(
          //   Icons.cancel_outlined,
          //   color: colorTheme.error,
          //   size: 12,
          // ),
          Icon(
            Icons.check_circle_outline,
            color: colorTheme.primary,
            size: 12,
          ),
        ],
      ),
    ];

    return ListTile(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext cxt) {
            return PropertyChannelScreen(
              title: '#${index + 1} ${propertiesList[index]}',              

            );
          },
        );

        debugPrint('Tapped on item ${propertiesList[index]}');
      },
      contentPadding: const EdgeInsets.only(
        left: 0,
        right: 24,
      ),
      leading: SizedBox(
        width: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('#${index + 1}'),
            const SizedBox(width: 4),
            Icon(Icons.video_settings, color: colorTheme.primary),
          ],
        ),
      ),
      trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.delete),
          color: colorTheme.error),
      title: Row(
        children: [
          screenWight < 700
              ? Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text(
                            propertiesList[index],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ],
                      ),
                      Opacity(
                        opacity: 1,
                        child: screenWight < 700
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: content,
                              )
                            : Row(
                                children: content,
                              ),
                      )
                    ],
                  ),
                )
              //screen > 700
              : SizedBox(
                  width: 210,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text(
                            propertiesList[index],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ],
                      ),
                      Opacity(
                        opacity: 1,
                        child: screenWight < 700
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: content,
                              )
                            : Row(
                                children: content,
                              ),
                      )
                    ],
                  ),
                ),
          const SizedBox(width: 16),
          screenWight < 700
              ? const SizedBox.shrink()
              : const Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Some promptSome promptSome promptSome promptSome promptSome promptSome promptSome promptSome promptSome promptSome promptSome promptSome promptSome promptSome promptSome promptSome promptSome promptSome promptSome promptSome promptSome promptSome promptSome promptSome promptSome promptSome promptSome promptSome promptSome promptSome promptSome promptSome promptSome promptSome prompt',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
