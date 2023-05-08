package com.laoshi.shier.service

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import com.laoshi.shier.R

class ForegroundService : Service() {
    private  val TAG = "ForegroundService"
    private var manager: NotificationManager? = null

    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        val title = intent.getStringExtra("title")
        val content = intent.getStringExtra("content")

        if(manager==null){
            manager =
                applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val channel = NotificationChannel(TAG, "通知", NotificationManager.IMPORTANCE_HIGH)
                manager!!.createNotificationChannel(channel)
            }
        }
        val notification =
            NotificationCompat.Builder(this.applicationContext, TAG)
                .setChannelId(TAG)
                .setContentTitle(title)
                .setContentText(content)
                .setWhen(System.currentTimeMillis())
                .setSmallIcon(R.drawable.icon_man)
                .setLargeIcon(BitmapFactory.decodeResource(this.resources, R.drawable.icon_man))
                .setOngoing(true)
                .build()
        startForeground(1, notification)
        return START_NOT_STICKY
    }

    override fun onBind(intent: Intent): IBinder? {
        return null
    }

    override fun onDestroy() {
        stopForeground(true)
        super.onDestroy()
    }
}