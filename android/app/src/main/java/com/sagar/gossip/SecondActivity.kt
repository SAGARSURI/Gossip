package com.sagar.gossip

import android.app.Activity
import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.os.Handler

class SecondActivity : Activity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_second)
        val runnable = Runnable {
            val intent = Intent()
            setResult(RESULT_OK, intent)
            finish()
        }
        val handler = Handler()
        handler.postDelayed(runnable,2000)
    }
}
