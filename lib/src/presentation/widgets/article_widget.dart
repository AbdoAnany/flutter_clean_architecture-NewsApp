import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/src/config/router/app_router.dart';
import 'package:flutter_clean_architecture/src/presentation/cubits/local_articles/local_articles_cubit.dart';
import 'package:ionicons/ionicons.dart';
import 'package:oktoast/oktoast.dart';

import '../../domain/models/article.dart';

class ArticleWidget extends StatelessWidget {
  final Article article;
  final bool isRemovable;
  final void Function(Article article)? onRemove;
  final void Function(Article article)? onArticlePressed;

  const ArticleWidget({
    Key? key,
    required this.article,
    this.onArticlePressed,
    this.isRemovable = false,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onTap,
      child: Container(
        width: MediaQuery.of(context).size.width ,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical:  7),
        height: MediaQuery.of(context).size.height / 4.45,
        child: Stack(
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.bottomCenter,
          children: [
            Hero(tag: article.id.toString()+article.urlToImage!,
            child: _buildImage(context)),
            Align(alignment: Alignment.topRight,
              child:   _buildRemovableArea(context),
            ),
            _buildTitleAndDescription(),

          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsetsDirectional.only(end: 14),
      width: MediaQuery.of(context).size.width ,
      height: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.black.withOpacity(0.08),
      ),
      child: Image.network(
        article.urlToImage ?? '',
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return const Center(
            child: Text(
              '404\nNOT FOUND',
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitleAndDescription() {
    return Container(

          clipBehavior: Clip.hardEdge,

          margin: const EdgeInsetsDirectional.only(end: 14),
        //  width: MediaQuery.of(context).size.width ,
       //   height: double.maxFinite/4,
          decoration: BoxDecoration(
             gradient: const LinearGradient(
               colors: [
                 Colors.black,
                 Colors.black87,
                 Colors.black54,
                 Colors.black45,
                 Colors.black38,
                 Colors.black26,
               ]
             ),
            borderRadius: BorderRadius.circular(20)

          ),


      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Hero(tag: article.id.toString()+article.title!,
            child: Text(
              article.title ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Butler',
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),

          // Description
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              article.description ?? '',
              maxLines: 2,style: TextStyle(color: Colors.white),
            ),
          ),

          // Datetime
          Row(
            children: [
              const Icon(Ionicons.time_outline, size: 16,color: Colors.white),
              const SizedBox(width: 4),
              Hero(tag: article.id.toString()+article.publishedAt!,
                child: Text(
                  article.publishedAt ?? '',
                  style: const TextStyle(
                    fontSize: 12,color: Colors.white
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRemovableArea(context) {
    if (isRemovable) {
      return GestureDetector(
        onTap: _onRemove,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 7),
          child: CircleAvatar(radius: 20, backgroundColor:  Colors.white54, child: Icon(Ionicons.trash_outline, color: Colors.red)),
        ),
      );
    }
    return InkWell(
      onTap: () {
        BlocProvider.of<LocalArticlesCubit>(context).saveArticle(article: article);
        showToast('Article Saved Successfully');
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 7),
        child: CircleAvatar(radius: 20,  backgroundColor:  Colors.black54,child: Icon(Ionicons.bookmark, color: Colors.white,size: 18,)),
      ),
    );
  }

  void _onTap() {
    if (onArticlePressed != null) {
      onArticlePressed?.call(article);
    }
  }

  void _onRemove() {
    if (onRemove != null) {
      onRemove?.call(article);
    }
  }
}
