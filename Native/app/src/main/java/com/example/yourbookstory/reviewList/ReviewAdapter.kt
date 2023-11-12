package com.example.yourbookstory.reviewList

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.RatingBar
import android.widget.TextView
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.RecyclerView.ViewHolder
import com.example.yourbookstory.R
import com.example.yourbookstory.data.Review

class ReviewAdapter(private val onClick: (Review) -> Unit): ListAdapter<Review, ReviewAdapter.ReviewViewHolder>(ReviewDiffCallback) {
    class ReviewViewHolder(itemView: View, val onClick: (Review) -> Unit): ViewHolder(itemView) {
        private var currentReview: Review? = null
        private val title: TextView = itemView.findViewById(R.id.bTitleAuthor)
        private val pros: TextView = itemView.findViewById(R.id.prosList)
        private val cons: TextView = itemView.findViewById(R.id.consList)
        private val rating: RatingBar = itemView.findViewById(R.id.rating)

        init {
            itemView.setOnClickListener {
                currentReview?.let(onClick)
            }
        }

        // Bind current review and display it on UI
        fun bind(review: Review) {
            currentReview = review

            title.text = buildString {
                append(currentReview?.bTitle)
                append(" by ")
                append(currentReview?.bAuthor)
            }
            val prosText = review.pros.joinToString("\n") { "+$it" }
            if (prosText == "+") {
                pros.visibility = View.GONE
            }
            else {
                pros.visibility = View.VISIBLE
                pros.text = prosText
            }
            val consText = review.cons.joinToString("\n") { "-$it" }
            if (consText == "-") {
                cons.visibility = View.GONE
            }
            else {
                cons.visibility = View.VISIBLE
                cons.text = consText
            }
            rating.rating = review.rating
        }

    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ReviewViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.review_item, parent, false)
        return ReviewViewHolder(view, onClick)
    }

    override fun onBindViewHolder(holder: ReviewViewHolder, position: Int) {
        val review = getItem(position)
        holder.bind(review)
    }

    object ReviewDiffCallback: DiffUtil.ItemCallback<Review>() {
        override fun areItemsTheSame(oldItem: Review, newItem: Review): Boolean {
            return oldItem == newItem
        }

        override fun areContentsTheSame(oldItem: Review, newItem: Review): Boolean {
            return oldItem.id == newItem.id
        }
    }
}