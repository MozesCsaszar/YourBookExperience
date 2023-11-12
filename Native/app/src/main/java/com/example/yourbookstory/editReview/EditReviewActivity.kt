package com.example.yourbookstory.editReview

import android.app.Activity
import android.app.AlertDialog
import android.content.DialogInterface
import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.EditText
import android.widget.LinearLayout
import android.widget.RatingBar
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.example.yourbookstory.R
import com.example.yourbookstory.data.Review

class EditReviewActivity : AppCompatActivity() {
    lateinit var bTitle: EditText
    lateinit var bAuthor: EditText
    lateinit var description: EditText
    lateinit var experience: EditText
    lateinit var pros: EditText
    lateinit var cons: EditText
    lateinit var score: TextView
    lateinit var review: Review
    lateinit var eRating: RatingBar
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.edit_activity)

        findViewById<TextView>(R.id.eBack).setOnClickListener {
            onClickBack()
        }
        findViewById<TextView>(R.id.eFinish).setOnClickListener {
            onClickUpdate()
        }
        findViewById<TextView>(R.id.eDelete).setOnClickListener {
             onClickDelete()
        }
        bTitle = findViewById<EditText>(R.id.ebTitle)
        bAuthor = findViewById<EditText>(R.id.ebAuthor)
        description = findViewById<LinearLayout>(R.id.eDescription).findViewById<EditText>(R.id.eContent)
        experience = findViewById<LinearLayout>(R.id.eExperience).findViewById<EditText>(R.id.eContent)
        pros = findViewById<LinearLayout>(R.id.ePros).findViewById<EditText>(R.id.eContent)
        cons = findViewById<LinearLayout>(R.id.eCons).findViewById<EditText>(R.id.eContent)
        eRating = findViewById<RatingBar>(R.id.eRating)

        if (intent.hasExtra("REVIEW")) {
            review = intent.getSerializableExtra("REVIEW") as Review
            bTitle.setText(review.bTitle)
            bAuthor.setText(review.bAuthor)
            description.setText(review.description)
            experience.setText(review.experiences)
            pros.setText(review.pros.joinToString("\n"))
            cons.setText(review.cons.joinToString("\n"))
            eRating.rating = review.rating.toFloat()
        }

        if(intent.getBooleanExtra("ADD", false)) {
            findViewById<TextView>(R.id.eTopBar).text = "Share Your Story"
            findViewById<TextView>(R.id.eDelete).visibility = View.INVISIBLE
            findViewById<TextView>(R.id.eFinish).text = "Add Story"
        }
        else {
            findViewById<TextView>(R.id.eDelete).visibility = View.VISIBLE
            findViewById<TextView>(R.id.eTopBar).text = "Update Your Story"
            findViewById<TextView>(R.id.eFinish).text = "Update Story"
        }
    }

    private fun onClickDelete() {
        val builder = AlertDialog.Builder(this)
        builder.setTitle("Delete Confirmation")
        builder.setMessage("You are about to delete this story. This is non-reversible. Are you sure you want to proceed?")
        builder.setPositiveButton("Yes") { _, _ -> doDelete()}
        builder.setNegativeButton("No") { _, _ -> }
        builder.show()
    }

    private fun doDelete() {
        val result = Intent()
        result.putExtra("REVIEW_ID", review.id)
        result.putExtra("DELETED", true)
        setResult(Activity.RESULT_OK, result)
        finish()
    }

    private fun onClickBack() {
        onBackPressed()
    }

    private fun onClickUpdate() {
        if(bTitle.text.toString() == "" || bAuthor.text.toString() == "" || eRating.rating == 0f) {
            val builder = AlertDialog.Builder(this)
            builder.setTitle("Unfilled Fields")
            builder.setMessage("Please make sure that the book title, author and rating fields are filled in.")
            builder.setPositiveButton("OK") {_, _ ->}
            builder.show()
        }
        else {
            doUpdate()
        }
    }

    private fun doUpdate() {
        val result = Intent()
        review.bTitle = bTitle.text.toString()
        review.bAuthor = bAuthor.text.toString()
        review.description = description.text.toString()
        review.experiences = experience.text.toString()
        review.pros = pros.text.toString().split("\n")
        review.cons = cons.text.toString().split("\n")
        review.rating = eRating.rating
        result.putExtra("REVIEW", review)
        setResult(Activity.RESULT_OK, result)
        finish()
    }
}