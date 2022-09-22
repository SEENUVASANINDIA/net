import java.io.*;
import java.net.*;
public class Eclient{
public static void main(String args[]){
Socket c=null;
String line;
DataInputStream is,is1;
PrintStream os;
try{
c=new Socket("localhost",8080);
}
catch(IOException e){
System.out.println(e);
}
try{
os=new PrintStream(c.getOutputStream());
is=new DataInputStream(System.in);
is1=new DataInputStream(c.getInputStream());
do{
System.out.println("client");
line=is.readLine();
os.println(line);
if(!line.equals("exit"))
System.out.println("server:"+is1.readLine());
}while(!line.equals("exit"));
}
catch(IOException e)
{
System.out.println("socket closed");
}}}
