#!/usr/bin/env python3
#coding:utf-8

import os
import subprocess
import tkinter

class ContainerExecuter():
    def __init__(self):
        self.tk = tkinter.Tk()
        self.running_containers_info = []       # 起動中のコンテナの一覧を格納する変数
        self.containers_info = []               # 全てのコンテナの一覧を格納する変数
        self.iconfile = tkinter.PhotoImage(file=os.path.dirname(__file__)+'/img/icon.png')
        self.tk.call('wm', 'iconphoto', self.tk._w, self.iconfile)

    def create_gui(self):
        self.get_containers_info(is_running = False)
        self.get_containers_info(is_running = True)

        self.tk.title("ContainerExecuter")

        # GUI windowの大きさを定義する
        geometry_x = str(700)
        # コンテナがない場合にもGUIが表示されるようにする
        geometry_y = str(30*2) if len(self.containers_info)<2 else str(30*len(self.containers_info))
        # "window width x window height + position right + position down"
        self.tk.geometry(("%sx%s+0+0")%(geometry_x, geometry_y))
        # self.tk.iconbitmap(default=self.iconfile)
        
        for i, container_info in enumerate(self.containers_info):
            container_id = container_info[0]
            container_name = container_info[len(container_info)-1].replace(" ","")

            # コンテナが実行中なのかどうか確認する
            is_running = False
            for running_container_info in self.running_containers_info:
                if container_id == running_container_info[0]:
                    is_running = True
                    break
            
            # コンテナの実行中の場合は"restart"，"stop"，"exec"というボタンを表示させる
            if is_running:
                tkinter.Button(self.tk, width=4, text="    ",    command=self.button_clicked_callback("dummy",   container_name)).place(x=100, y=i*30)
                tkinter.Button(self.tk, width=4, text="restart", command=self.button_clicked_callback("restart", container_name)).place(x=160, y=i*30)
                tkinter.Button(self.tk, width=4, text="stop",    command=self.button_clicked_callback("stop",    container_name)).place(x=220, y=i*30)
                tkinter.Button(self.tk, width=4, text="exec",    command=self.button_clicked_callback("exec",    container_name)).place(x=280, y=i*30)

            else:
                tkinter.Button(self.tk, width=4, text="start", command=self.button_clicked_callback("start", container_name)).place(x=100, y=i*30)
                tkinter.Button(self.tk, width=4, text="    ",  command=self.button_clicked_callback("dummy", container_name)).place(x=160, y=i*30)
                tkinter.Button(self.tk, width=4, text="    ",  command=self.button_clicked_callback("dummy", container_name)).place(x=220, y=i*30)
                tkinter.Button(self.tk, width=4, text="    ",  command=self.button_clicked_callback("dummy", container_name)).place(x=280, y=i*30)

            tkinter.Label(text=container_name, font=("",15)).place(x=340, y=i*30)
            tkinter.Button(self.tk, width=4, text="down", fg="red", command=self.button_clicked_callback("down", container_name)).place(x=750, y=i*30)
	    #GUI再起動用のボタンを定義
        btn = tkinter.Button(self.tk, width=3, text="refresh", command=self.refresh_gui)
        btn.place(x=0, y=0)
        
        #GUI停止用のボタンを定義
        btn = tkinter.Button(self.tk, width=3, text="close", command=self.quit_gui)
        btn.place(x=0, y=30)

        self.tk.mainloop()


    def button_clicked_callback(self, operation, container_name):
        def inner():
            if operation == "dummy":
                pass

            else:
                service_name = self.get_service_name(container_name)

                if operation == "exec":
                    print("[%s] container has been executed."%container_name)
                    cmd = "gnome-terminal -- bash -c 'docker compose -p %s exec -it --user ${USERNAME} %s /bin/bash; bash'"%(container_name, service_name)

                elif operation == "start":
                    print("[%s] container has been started."%container_name)
                    cmd = "docker compose -p %s start "%(container_name)

                elif operation == "restart":
                    print("[%s] container has been restarted."%container_name)
                    cmd = "docker compose -p %s restart "%(container_name)

                elif operation == "stop":
                    print("[%s] container has been stopped."%container_name)
                    cmd = "docker compose -p %s stop "%(container_name)

                elif operation == "down":
                    print("[%s] container is being downed..."%container_name)
                    cmd = "docker compose -p %s down "%(container_name)
                    
                os.system(cmd) #回避策としてos.systemを使用
                self.refresh_gui()

        return inner 
    
    # [close]ボタンを押すと，GUIを終了させる
    def quit_gui(self):
        print("[close] button has been clicked.")
        self.tk.quit()
        self.tk.destroy()

    # [refresh]ボタンを押すと，GUIを再起動する
    def refresh_gui(self):
        print("[refresh] button has been clicked.")
        self.running_containers_info = []
        self.containers_info = []
        self.tk.quit()
        self.tk.destroy()
        self.__init__()
        self.create_gui()

    # コンテナの情報を登録する関数
    def get_containers_info(self, is_running=False):
        cmd = "docker ps" if is_running else "docker ps -a"
        res = subprocess.Popen(cmd, stdout=subprocess.PIPE,
                               shell=True).communicate()[0]

        try:    #for python2
            containers_info = res.split("\n")
        except: #for python3
            res = res.decode()
            containers_info = res.split("\n")

        for i, container_info in enumerate(containers_info):
            # 配列の最初と最後の要素は余計なものが入るのでパス
            if i>0 and i<len(containers_info)-1:
                container_info = container_info.split("   ")
                
                # 空欄の要素を除去
                container_info =  [x for x in container_info if x]
                if is_running :  self.running_containers_info.append(container_info)
                else :           self.containers_info.append(container_info)

    # コンテナ名からdocker-composeのサービス名を取得する関数
    def get_service_name(self, container_name):
            try:
                cmd = ["docker", "inspect", "-f", '{{ index .Config.Labels "com.docker.compose.service" }}', container_name]
                service_name = subprocess.check_output(cmd).decode().strip()
                return service_name
            except Exception as e:
                print(f"Error getting service name for {container_name}: {e}")
                return None
    

def main():
    ce = ContainerExecuter()
    ce.create_gui()

if __name__ == "__main__":
    main()