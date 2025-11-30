package com.rsv.bdd;

import com.rsv.model.FicheDePaie;
import com.rsv.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.ArrayList;
import java.util.List;

/**
 * DAO pour gérer les fiches de paie
 */
public class FicheDePaieDAO {

    /**
     * Liste toutes les fiches de paie
     */
    public List<FicheDePaie> listerToutes() {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            String hql = "FROM FicheDePaie ORDER BY annee DESC, mois DESC";
            return session.createQuery(hql, FicheDePaie.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    /**
     * Alias pour listerToutes() - pour compatibilité avec RecalculerFichesServlet
     */
    public List<FicheDePaie> listerToutesLesFiches() {
        return listerToutes();
    }

    /**
     * Récupère une fiche par son ID
     */
    public FicheDePaie getFicheById(Integer id) {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            return session.get(FicheDePaie.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    /**
     * Ajoute une nouvelle fiche
     */
    public boolean ajouterFiche(FicheDePaie fiche) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            
            // Calculer automatiquement les cotisations et le net
            fiche.calculerTout();
            
            session.persist(fiche);
            
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
            System.err.println("ERREUR lors de l'ajout de la fiche : " + e.getMessage());
            return false;
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    /**
     * Modifie une fiche existante
     */
    public boolean modifierFicheDePaie(FicheDePaie fiche) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            
            // Recalculer automatiquement les cotisations et le net
            fiche.calculerTout();
            
            session.merge(fiche);
            
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
            System.err.println("ERREUR lors de la modification de la fiche : " + e.getMessage());
            return false;
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    /**
     * Supprime une fiche
     */
    public boolean supprimerFiche(Integer id) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            
            FicheDePaie fiche = session.get(FicheDePaie.class, id);
            if (fiche != null) {
                session.remove(fiche);
            }
            
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
            return false;
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    /**
     * Récupère toutes les fiches d'un employé
     */
    public List<FicheDePaie> getFichesParEmploye(Integer employeId) {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            String hql = "FROM FicheDePaie WHERE employe.id = :employeId ORDER BY annee DESC, mois DESC";
            Query<FicheDePaie> query = session.createQuery(hql, FicheDePaie.class);
            query.setParameter("employeId", employeId);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    /**
     * Récupère toutes les fiches d'une période donnée
     */
    public List<FicheDePaie> getFichesParPeriode(Integer mois, Integer annee) {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            String hql = "FROM FicheDePaie WHERE mois = :mois AND annee = :annee ORDER BY employe.nom";
            Query<FicheDePaie> query = session.createQuery(hql, FicheDePaie.class);
            query.setParameter("mois", mois);
            query.setParameter("annee", annee);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }
}