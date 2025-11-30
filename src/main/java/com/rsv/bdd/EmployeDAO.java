package com.rsv.bdd;

import com.rsv.model.Employe;
import com.rsv.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.ArrayList;
import java.util.List;

/**
 * DAO pour gérer les employés dans la base de données
 */
public class EmployeDAO {

    /**
     * Ajoute un nouvel employé dans la base de données
     */
    public boolean ajouterEmploye(Employe employe) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            
            session.persist(employe);
            
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
     * Modifie un employé existant
     */
    public boolean modifierEmploye(Employe employe) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            
            session.merge(employe);
            
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
     * Supprime un employé par son ID
     */
    public boolean supprimerEmploye(Integer id) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            
            Employe employe = session.get(Employe.class, id);
            if (employe != null) {
                session.remove(employe);
                transaction.commit();
                return true;
            }
            
            transaction.rollback();
            return false;
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
     * Récupère un employé par son ID
     */
    public Employe getEmployeById(Integer id) {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            return session.get(Employe.class, id);
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
     * Liste tous les employés
     */
    public List<Employe> listerTous() {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            String hql = "FROM Employe ORDER BY nom, prenom";
            Query<Employe> query = session.createQuery(hql, Employe.class);
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
     * Recherche un employé par son matricule
     */
    public Employe rechercherParMatricule(String matricule) {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            String hql = "FROM Employe WHERE matricule = :matricule";
            Query<Employe> query = session.createQuery(hql, Employe.class);
            query.setParameter("matricule", matricule);
            return query.uniqueResult();
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
     * Recherche des employés par nom
     */
    public List<Employe> rechercherParNom(String nom) {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            String hql = "FROM Employe WHERE LOWER(nom) LIKE LOWER(:nom)";
            Query<Employe> query = session.createQuery(hql, Employe.class);
            query.setParameter("nom", "%" + nom + "%");
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
     * Recherche des employés par prénom
     */
    public List<Employe> rechercherParPrenom(String prenom) {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            String hql = "FROM Employe WHERE LOWER(prenom) LIKE LOWER(:prenom)";
            Query<Employe> query = session.createQuery(hql, Employe.class);
            query.setParameter("prenom", "%" + prenom + "%");
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
     * Liste les employés par département
     */
    public List<Employe> listerParDepartement(Integer departementId) {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            String hql = "FROM Employe WHERE departement.id = :deptId";
            Query<Employe> query = session.createQuery(hql, Employe.class);
            query.setParameter("deptId", departementId);
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
     * Liste les employés par grade
     */
    public List<Employe> listerParGrade(String grade) {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            String hql = "FROM Employe WHERE grade = :grade";
            Query<Employe> query = session.createQuery(hql, Employe.class);
            query.setParameter("grade", grade);
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
     * Liste les employés par poste
     */
    public List<Employe> listerParPoste(String poste) {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            String hql = "FROM Employe WHERE LOWER(poste) LIKE LOWER(:poste)";
            Query<Employe> query = session.createQuery(hql, Employe.class);
            query.setParameter("poste", "%" + poste + "%");
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
     * Compte le nombre total d'employés
     */
    public long compterEmployes() {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            String hql = "SELECT COUNT(e) FROM Employe e";
            Query<Long> query = session.createQuery(hql, Long.class);
            Long count = query.uniqueResult();
            return count != null ? count : 0L;
        } catch (Exception e) {
            e.printStackTrace();
            return 0L;
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    /**
     * Compte le nombre d'employés par département
     */
    public long compterParDepartement(Integer departementId) {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            String hql = "SELECT COUNT(e) FROM Employe e WHERE e.departement.id = :deptId";
            Query<Long> query = session.createQuery(hql, Long.class);
            query.setParameter("deptId", departementId);
            Long count = query.uniqueResult();
            return count != null ? count : 0L;
        } catch (Exception e) {
            e.printStackTrace();
            return 0L;
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    /**
     * Compte le nombre d'employés par grade
     */
    public long compterParGrade(String grade) {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            String hql = "SELECT COUNT(e) FROM Employe e WHERE e.grade = :grade";
            Query<Long> query = session.createQuery(hql, Long.class);
            query.setParameter("grade", grade);
            Long count = query.uniqueResult();
            return count != null ? count : 0L;
        } catch (Exception e) {
            e.printStackTrace();
            return 0L;
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    /**
     * Alias pour rechercherParMatricule (compatibilité InscriptionServlet)
     */
    public Employe getEmployeByMatricule(String matricule) {
        return rechercherParMatricule(matricule);
    }

    /**
     * Récupère un employé avec ses projets chargés (pour éviter LazyInitializationException)
     */
    public Employe getEmployeAvecProjets(Integer id) {
        Session session = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            
            String hql = "SELECT DISTINCT e FROM Employe e LEFT JOIN FETCH e.projets WHERE e.id = :id";
            Query<Employe> query = session.createQuery(hql, Employe.class);
            query.setParameter("id", id);
            
            return query.uniqueResult();
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
     * Modifie un employé ET met à jour ses affectations aux projets
     * @param employe L'employé à modifier
     * @param projetIds Liste des IDs des projets auxquels affecter l'employé
     * @return true si succès, false sinon
     */
    public boolean modifierEmployeAvecProjets(Employe employe, List<Integer> projetIds) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            transaction = session.beginTransaction();
            
            // Charger l'employé existant
            Employe employeExistant = session.get(Employe.class, employe.getId());
            if (employeExistant == null) {
                transaction.rollback();
                return false;
            }
            
            // Mettre à jour les champs de base
            employeExistant.setNom(employe.getNom());
            employeExistant.setPrenom(employe.getPrenom());
            employeExistant.setEmail(employe.getEmail());
            employeExistant.setTelephone(employe.getTelephone());
            employeExistant.setAdresse(employe.getAdresse());
            employeExistant.setPoste(employe.getPoste());
            employeExistant.setGrade(employe.getGrade());
            employeExistant.setSalaire(employe.getSalaire());
            employeExistant.setDateEmbauche(employe.getDateEmbauche());
            employeExistant.setDepartement(employe.getDepartement());
            
            // CORRECTION: Modifier le côté OWNER (Projet.employes) au lieu de Employe.projets
            // 1. Charger TOUS les projets avec leurs employés
            String hqlAllProjets = "SELECT DISTINCT p FROM Projet p LEFT JOIN FETCH p.employes";
            Query<com.rsv.model.Projet> queryProjets = session.createQuery(hqlAllProjets, com.rsv.model.Projet.class);
            java.util.List<com.rsv.model.Projet> tousProjets = queryProjets.getResultList();
            
            // 2. Pour chaque projet, synchroniser la présence de l'employé
            java.util.Set<Integer> projetIdsSet = new java.util.HashSet<>(projetIds != null ? projetIds : java.util.Collections.emptyList());
            
            for (com.rsv.model.Projet projet : tousProjets) {
                boolean employeDoitEtreDansProjet = projetIdsSet.contains(projet.getId());
                boolean employeEstDansProjet = projet.getEmployes().stream()
                        .anyMatch(e -> e.getId().equals(employe.getId()));
                
                if (employeDoitEtreDansProjet && !employeEstDansProjet) {
                    // AJOUTER l'employé au projet (modification du côté OWNER)
                    projet.getEmployes().add(employeExistant);
                    session.merge(projet);
                    System.out.println("✅ Employé " + employe.getPrenom() + " " + employe.getNom() + " ajouté au projet " + projet.getNom());
                } else if (!employeDoitEtreDansProjet && employeEstDansProjet) {
                    // RETIRER l'employé du projet (modification du côté OWNER)
                    projet.getEmployes().removeIf(e -> e.getId().equals(employe.getId()));
                    session.merge(projet);
                    System.out.println("🗑️ Employé " + employe.getPrenom() + " " + employe.getNom() + " retiré du projet " + projet.getNom());
                }
            }
            
            // Sauvegarder l'employé
            session.merge(employeExistant);
            
            // Forcer la synchronisation avec la base de données
            session.flush();
            transaction.commit();
            
            System.out.println("✅ Employé modifié avec succès avec " + projetIdsSet.size() + " projet(s)");
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
}