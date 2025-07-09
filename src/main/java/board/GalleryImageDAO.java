package board;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


public class GalleryImageDAO {

	private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

	
    private static GalleryImageDAO instance = new GalleryImageDAO();
    public static GalleryImageDAO getInstance() { return instance; }
    private GalleryImageDAO() {}
    
    private Connection connect() {
        try {
            Class.forName("org.postgresql.Driver");
            String url = 
                "jdbc:postgresql://"
              + "dpg-d1egnpje5dus73bdibt0-a.singapore-postgres.render.com"
              + ":5432/redbearstorage?sslmode=require";
            String user = "redbearstorage_user";
            String pass = "3MIkZPNJS880iE9NhM0f5s73EQ3MbcFQ";
            return DriverManager.getConnection(url, user, pass);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // 리소스 해제
    private void disconnect() {
        try { if (rs    != null) rs.close();    } catch (SQLException ignored) {}
        try { if (pstmt != null) pstmt.close(); } catch (SQLException ignored) {}
        try { if (conn  != null) conn.close();  } catch (SQLException ignored) {}
    }
    
    
    public void insertImage(int galleryNum, String imageUrl) {
        String sql = "INSERT INTO gallery_image (gallery_num, image_url) VALUES (?, ?)";
        try {
        	conn = connect();
        	PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, galleryNum);
            pstmt.setString(2, imageUrl);
            pstmt.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public List<String> getImages(int galleryNum) {
        List<String> list = new ArrayList<>();
        String sql = "SELECT image_url FROM gallery_image WHERE gallery_num = ?";
        try {
        	conn = connect();
        	PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, galleryNum);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) list.add(rs.getString(1));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}
